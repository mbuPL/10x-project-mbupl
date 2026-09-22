#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf 'Usage: bash scripts/smoke-http.sh BASE_URL\n' >&2
  exit 2
fi

# Node is already installed for the frontend build and provides fetch and JSON parsing.
node --input-type=module - "$1" <<'NODE'
import assert from 'node:assert/strict';
import { setTimeout as sleep } from 'node:timers/promises';

const base = new URL(process.argv[2]);
assert(['http:', 'https:'].includes(base.protocol), 'BASE_URL must use HTTP or HTTPS');
assert(!base.username && !base.password, 'BASE_URL must not contain credentials');
assert(base.pathname === '/' && !base.search && !base.hash, 'BASE_URL must be an origin without a path or query');
const timeoutSeconds = Number(process.env.SMOKE_READY_TIMEOUT_SECONDS ?? 300);
assert(Number.isFinite(timeoutSeconds) && timeoutSeconds > 0, 'Readiness timeout must be positive');

async function request(path, { method = 'GET', accept = '*/*' } = {}) {
  const url = new URL(path, base);
  assert.equal(url.origin, base.origin, 'Smoke requests must remain on the application origin');
  const response = await fetch(url, {
    method,
    headers: { Accept: accept },
    redirect: 'manual',
    signal: AbortSignal.timeout(10_000),
  });
  return {
    status: response.status,
    type: (response.headers.get('content-type') ?? '').split(';')[0].trim(),
    body: await response.text(),
  };
}

const deadline = Date.now() + timeoutSeconds * 1000;
let readinessFailure;
let ready = false;
while (Date.now() < deadline) {
  try {
    const health = await request('/api/health', { accept: 'application/json' });
    assert.equal(health.status, 200, 'Health HTTP status');
    assert.equal(health.type, 'application/json', 'Health content type');
    assert.equal(JSON.parse(health.body).status, 'UP', 'Health status');
    readinessFailure = undefined;
    ready = true;
    break;
  } catch (error) {
    readinessFailure = error;
    await sleep(2000);
  }
}
assert(ready, `Readiness timed out: ${readinessFailure?.message ?? 'No successful response'}`);

const index = await request('/', { accept: 'text/html' });
assert.equal(index.status, 200, 'Index HTTP status');
assert.equal(index.type, 'text/html', 'Index content type');
assert.match(index.body, /<app-root(?:\s|>)/i, 'Angular root element');

function attribute(tag, name) {
  return new RegExp(`\\b${name}\\s*=\\s*(["'])(.*?)\\1`, 'i').exec(tag)?.[2];
}

const scripts = index.body.match(/<script\b[^>]*>/gi) ?? [];
const main = scripts.map(tag => attribute(tag, 'src')).find(src => src && /(?:^|\/)main(?:[-.][^/]*)?\.js(?:\?|$)/.test(src));
const styles = (index.body.match(/<link\b[^>]*>/gi) ?? [])
  .filter(tag => attribute(tag, 'rel')?.toLowerCase() === 'stylesheet')
  .map(tag => attribute(tag, 'href'))
  .filter(Boolean);
assert(main, 'Index must reference a main JavaScript bundle');
assert(styles.length > 0, 'Index must reference a stylesheet');

for (const [path, expectedTypes] of [[main, ['text/javascript', 'application/javascript']], ...styles.map(path => [path, ['text/css']])]) {
  const asset = await request(path);
  assert.equal(asset.status, 200, `Asset HTTP status: ${path}`);
  assert(expectedTypes.includes(asset.type), `Unexpected content type for ${path}: ${asset.type}`);
  // The scaffold's empty global stylesheet is a valid production build output.
  if (path === main) assert(asset.body.trim().length > 0, `JavaScript must not be empty: ${path}`);
  assert(!asset.body.includes('<app-root'), `Asset returned the SPA shell: ${path}`);
}

const route = '/__deployment-smoke__/client-route';
const fallback = await request(route, { accept: 'text/html' });
assert.equal(fallback.status, 200, 'SPA route HTTP status');
assert.equal(fallback.type, 'text/html', 'SPA route content type');
assert.equal(fallback.body, index.body, 'SPA route must return the index');
const head = await request(route, { method: 'HEAD', accept: 'text/html' });
assert.equal(head.status, 200, 'SPA HEAD status');
assert.equal(head.type, 'text/html', 'SPA HEAD content type');
assert.equal(head.body, '', 'HEAD must not return a body');

for (const path of ['/api', '/api/__deployment-smoke__', '/actuator', '/h2-console', '/.env', '/__deployment-smoke__/missing.js', '/__deployment-smoke__/missing.css']) {
  const missing = await request(path, { accept: 'text/html' });
  assert.equal(missing.status, 404, `Missing route must keep 404: ${path}`);
  assert(!missing.body.includes('<app-root'), `Missing route must not return the SPA: ${path}`);
}

const error = await request('/error', { accept: 'text/html' });
assert(error.status >= 400, 'Reserved /error must remain an error');
assert(!error.body.includes('<app-root'), '/error must not return the SPA');
const post = await request(route, { method: 'POST', accept: 'text/html' });
assert(post.status >= 400 && post.status < 500, 'POST to a client route must be rejected');
assert(!post.body.includes('<app-root'), 'POST must not return the SPA');
const jsonRoute = await request(route, { accept: 'application/json' });
assert.equal(jsonRoute.status, 404, 'A JSON client must not receive the SPA fallback');

console.log(`HTTP smoke passed: ${base.origin} (health, index, assets, SPA routing, reserved paths).`);
NODE
