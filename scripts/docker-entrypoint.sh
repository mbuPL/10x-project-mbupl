#!/bin/sh
set -eu

fail() {
  printf 'Startup refused: %s\n' "$1" >&2
  exit 1
}

case "${DB_PASSWORD:-}" in
  *[![:space:]]*) ;;
  *) fail 'DB_PASSWORD must contain a non-whitespace character.' ;;
esac

[ "${DB_PATH:-}" = '/data/skarb-kibica' ] ||
  fail 'DB_PATH must be /data/skarb-kibica.'

command -v mountpoint >/dev/null 2>&1 || fail 'mountpoint is unavailable in the runtime image.'
mountpoint -q /data || fail '/data must be a mounted persistent volume.'

write_probe=$(mktemp /data/.startup-write-check.XXXXXX) ||
  fail '/data must be writable.'
rm -f -- "$write_probe" || fail 'Cannot remove the /data write probe.'

# Replacing the shell lets Java receive SIGTERM and close H2 cleanly.
exec java -jar /app/app.jar
