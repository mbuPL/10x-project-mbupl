#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  printf 'Usage: bash scripts/smoke-container.sh IMAGE\n' >&2
  exit 2
fi

image=$1
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
command -v docker >/dev/null || { printf 'Docker is required.\n' >&2; exit 1; }
command -v node >/dev/null || { printf 'Node.js is required.\n' >&2; exit 1; }
docker info >/dev/null

containers=()
volume_id=''
current_container=''
# Pass the disposable password through the environment, never a CLI argument or log.
DB_PASSWORD=$(node -e 'process.stdout.write(require("node:crypto").randomBytes(32).toString("hex"))')
export DB_PASSWORD

cleanup() {
  local result=$?
  trap - EXIT
  local container_id
  # The guarded expansion also supports macOS Bash 3 with nounset and an empty array.
  for container_id in ${containers[@]+"${containers[@]}"}; do
    if [[ $result -ne 0 ]]; then
      printf 'Recent logs for smoke container %s:\n' "$container_id" >&2
      docker logs --tail 100 "$container_id" 2>&1 |
        node -e 'let input="";process.stdin.on("data",c=>input+=c);process.stdin.on("end",()=>process.stderr.write(input.replaceAll(process.env.DB_PASSWORD,"[REDACTED]")));' || true
    fi
    docker rm --force "$container_id" >/dev/null 2>&1 || true
  done
  if [[ -n "$volume_id" ]]; then
    docker volume rm "$volume_id" >/dev/null 2>&1 || true
  fi
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

volume_id=$(docker volume create)

create_container() {
  current_container=$(docker create --memory 1g --cpus 1 \
    --env DB_PASSWORD --env DB_PATH=/data/skarb-kibica \
    --env DB_USERNAME=sa --env PORT=8080 "$@" "$image")
  containers+=("$current_container")
}

expect_rejection() {
  local label=$1 expected=$2
  shift 2
  create_container "$@"
  docker start "$current_container" >/dev/null
  local attempt running='true'
  for ((attempt = 0; attempt < 30; attempt++)); do
    running=$(docker inspect --format '{{.State.Running}}' "$current_container")
    [[ "$running" = false ]] && break
    sleep 0.2
  done
  [[ "$running" = false ]] || { printf 'Startup unexpectedly continued: %s\n' "$label" >&2; return 1; }
  [[ $(docker inspect --format '{{.State.ExitCode}}' "$current_container") = 1 ]] || {
    printf 'Expected entrypoint rejection: %s\n' "$label" >&2
    return 1
  }
  local logs
  logs=$(docker logs "$current_container" 2>&1)
  [[ "$logs" = *"$expected"* ]] || { printf 'Unexpected rejection reason: %s\n' "$label" >&2; return 1; }
  printf 'Startup guard passed: %s.\n' "$label"
}

expect_rejection 'missing password' 'DB_PASSWORD must contain' \
  --env DB_PASSWORD= --mount "type=volume,source=$volume_id,target=/data"
expect_rejection 'blank password' 'DB_PASSWORD must contain' \
  --env 'DB_PASSWORD=   ' --mount "type=volume,source=$volume_id,target=/data"
expect_rejection 'incorrect database path' 'DB_PATH must be' \
  --env DB_PATH=/tmp/skarb-kibica --mount "type=volume,source=$volume_id,target=/data"
expect_rejection 'missing persistent mount' '/data must be a mounted persistent volume.'
expect_rejection 'read-only volume' '/data must be writable.' \
  --mount "type=volume,source=$volume_id,target=/data,readonly"

start_application() {
  create_container --mount "type=volume,source=$volume_id,target=/data" --publish 127.0.0.1::8080
  docker start "$current_container" >/dev/null
  local address
  address=$(docker port "$current_container" 8080/tcp)
  bash "$script_dir/smoke-http.sh" "http://$address"
}

start_application
first_container=$current_container
marker="smoke-$volume_id"
docker exec "$first_container" sh -eu -c '
  test -s /data/skarb-kibica.mv.db
  printf "%s\n" "$1" > /data/.deployment-smoke-marker
' sh "$marker"

docker restart --time 30 "$first_container" >/dev/null
address=$(docker port "$first_container" 8080/tcp)
bash "$script_dir/smoke-http.sh" "http://$address"
docker exec "$first_container" sh -eu -c '
  test -s /data/skarb-kibica.mv.db
  test "$(cat /data/.deployment-smoke-marker)" = "$1"
' sh "$marker"

# Only one process may open the file database at a time.
docker stop --time 30 "$first_container" >/dev/null
start_application
docker exec "$current_container" sh -eu -c '
  test -s /data/skarb-kibica.mv.db
  test "$(cat /data/.deployment-smoke-marker)" = "$1"
' sh "$marker"
docker stop --time 30 "$current_container" >/dev/null

printf 'Container smoke passed: startup guards, HTTP, restart and replacement preserve the volume and H2 file.\n'
printf 'The volume marker is not a database recovery test; Maven verifies persisted H2 records.\n'
