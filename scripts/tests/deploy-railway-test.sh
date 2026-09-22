#!/usr/bin/env bash
set -euo pipefail

test_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=../deploy-railway.sh
source "$test_dir/../deploy-railway.sh"

PROJECT_ID=11111111-1111-4111-8111-111111111111
ENVIRONMENT_ID=22222222-2222-4222-8222-222222222222
SERVICE_ID=33333333-3333-4333-8333-333333333333
APP_URL=https://example.up.railway.app
RAILWAY_TOKEN=not-a-real-token
GITHUB_SHA=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
GITHUB_REF=refs/heads/main
GITHUB_REPOSITORY=example/project
GITHUB_TOKEN=not-a-real-token
GITHUB_STEP_SUMMARY=
target_deployment=44444444-4444-4444-8444-444444444444
mock_time=0
scenario=success
tests_passed=0

# Replace every external service and wait. These tests never contact Railway or GitHub.
date() { printf '%s\n' "$mock_time"; }
sleep() { mock_time=$((mock_time + $1)); }
timeout() { shift 3; "$@"; }
curl() {
  case "$scenario" in
    github_error) return 1 ;;
    github_malformed) printf '{"message":"not a ref"}\n' ;;
    stale) printf '{"object":{"sha":"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"}}\n' ;;
    *) printf '{"object":{"sha":"%s"}}\n' "$GITHUB_SHA" ;;
  esac
}
railway() {
  if [[ "$1" == --version ]]; then
    printf 'railway 5.59.0\n'
    return
  fi
  if [[ "$1" == up ]]; then
    if [[ "$scenario" == stale ]]; then
      deployment_error 'An obsolete commit must not be uploaded.'
      return 99
    fi
    if [[ "$*" != "up --project $PROJECT_ID --environment $ENVIRONMENT_ID --service $SERVICE_ID --detach --json --message $GITHUB_SHA" ]]; then
      deployment_error 'Incorrect upload target, mode, or commit message.'
      return 99
    fi
    case "$scenario" in
      upload_error) return 1 ;;
      upload_malformed) printf '{"message":"missing deployment ID"}\n' ;;
      *) printf '{"deploymentId":"%s","logsUrl":"https://example.invalid/logs"}\n' "$target_deployment" ;;
    esac
    return
  fi
  [[ "$1 $2" == 'deployment list' ]] || return 99
  [[ "$*" == "deployment list --project $PROJECT_ID --environment $ENVIRONMENT_ID --service $SERVICE_ID --limit 100 --json" ]] || return 99
  case "$scenario" in
    full_success|smoke_failure) printf '[{"id":"%s","status":"SUCCESS"}]\n' "$target_deployment" ;;
    cli_error) return 1 ;;
    malformed) printf '{"error":"not a deployment list"}\n' ;;
    missing_status) printf '[{"id":"%s"}]\n' "$target_deployment" ;;
    old_success) printf '[{"id":"old-deployment","status":"SUCCESS"}]\n' ;;
    delayed)
      if (( mock_time < 10 )); then
        printf '[{"id":"old-deployment","status":"SUCCESS"},{"id":"%s","status":"BUILDING"}]\n' "$target_deployment"
      else
        printf '[{"id":"%s","status":"SUCCESS"}]\n' "$target_deployment"
      fi
      ;;
    *) printf '[{"id":"%s","status":"%s"}]\n' "$target_deployment" "$scenario" ;;
  esac
}
bash() {
  if [[ "$1" != */smoke-http.sh || "$2" != "$APP_URL" ]]; then
    deployment_error 'The HTTP smoke check received incorrect arguments.'
    return 99
  fi
  if [[ "$scenario" == smoke_failure ]]; then
    deployment_error 'Mock public HTTP check failed.'
    return 1
  fi
  printf 'Mock public HTTP check passed.\n'
}

expect_pass() {
  local label=$1 output
  shift
  if ! output=$("$@" 2>&1); then
    printf 'FAIL %s\n%s\n' "$label" "$output" >&2
    exit 1
  fi
  tests_passed=$((tests_passed + 1))
}

expect_failure() {
  local label=$1 expected=$2 output
  shift 2
  if output=$("$@" 2>&1); then
    printf 'FAIL %s: command unexpectedly succeeded\n%s\n' "$label" "$output" >&2
    exit 1
  fi
  if [[ "$output" != *"$expected"* ]]; then
    printf 'FAIL %s: missing expected diagnostic %s\n%s\n' "$label" "$expected" "$output" >&2
    exit 1
  fi
  tests_passed=$((tests_passed + 1))
}

expect_pass 'Valid production environment' validate_deployment_environment
GITHUB_REF=refs/heads/feature
expect_failure 'Refuse a branch deployment' 'must run from main' validate_deployment_environment
GITHUB_REF=refs/heads/main
APP_URL=http://example.up.railway.app
expect_failure 'Require HTTPS' 'HTTPS origin' validate_deployment_environment
APP_URL=https://example.up.railway.app
RAILWAY_TOKEN=
expect_failure 'Require scoped credentials' 'RAILWAY_TOKEN' validate_deployment_environment
RAILWAY_TOKEN=not-a-real-token

scenario=SUCCESS
expect_pass 'Exact deployment succeeded' wait_for_deployment "$target_deployment"
scenario=delayed
expect_pass 'Ignore older success while the target builds' wait_for_deployment "$target_deployment"
scenario=old_success
expect_failure 'Old success cannot satisfy this deployment' 'Timed out after 20 minutes' wait_for_deployment "$target_deployment"
for scenario in FAILED CRASHED REMOVED REMOVING SKIPPED NEEDS_APPROVAL SLEEPING UNKNOWN; do
  expect_failure "Fail closed on $scenario" "did not succeed ($scenario)" wait_for_deployment "$target_deployment"
done
scenario=cli_error
expect_failure 'CLI read failure' 'Cannot read the status' wait_for_deployment "$target_deployment"
for scenario in malformed missing_status; do
  expect_failure "Reject $scenario status response" 'invalid deployment status response' wait_for_deployment "$target_deployment"
done
scenario=stale
expect_pass 'Skip an obsolete main SHA before upload' deploy_railway
scenario=github_error
expect_failure 'No deploy when GitHub is unreachable' 'Cannot check the current main commit' deploy_railway
scenario=github_malformed
expect_failure 'No deploy with invalid GitHub response' 'invalid main commit' deploy_railway
scenario=upload_error
expect_failure 'Upload failure stops deployment' 'Railway upload failed' deploy_railway
scenario=upload_malformed
expect_failure 'Upload must return its deployment ID' 'valid deployment ID' deploy_railway
scenario=full_success
expect_pass 'Upload the exact target and pass public HTTP checks' deploy_railway
scenario=smoke_failure
expect_failure 'Public HTTP failure fails the deployment job' 'Mock public HTTP check failed' deploy_railway

printf 'Deployment script: %s tests passed.\n' "$tests_passed"
