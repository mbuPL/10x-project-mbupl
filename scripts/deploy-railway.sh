#!/usr/bin/env bash
set -euo pipefail

deployment_error() {
  printf 'Deployment error: %s\n' "$*" >&2
}

validate_deployment_environment() {
  local name
  for name in PROJECT_ID ENVIRONMENT_ID SERVICE_ID APP_URL RAILWAY_TOKEN GITHUB_SHA GITHUB_REF GITHUB_REPOSITORY GITHUB_TOKEN; do
    if [[ -z "${!name:-}" ]]; then
      deployment_error "Missing required environment variable: $name"
      return 1
    fi
  done
  for name in PROJECT_ID ENVIRONMENT_ID SERVICE_ID; do
    if [[ ! "${!name}" =~ ^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$ ]]; then
      deployment_error "$name must contain a Railway UUID."
      return 1
    fi
  done
  if [[ "$GITHUB_REF" != refs/heads/main ]]; then
    deployment_error 'Production deployments must run from main.'
    return 1
  fi
  if [[ ! "$GITHUB_SHA" =~ ^[[:xdigit:]]{40}$ ]] || [[ ! "$GITHUB_REPOSITORY" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
    deployment_error 'Invalid GitHub commit or repository.'
    return 1
  fi
  if [[ ! "$APP_URL" =~ ^https://[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?/?$ ]]; then
    deployment_error 'APP_URL must be an HTTPS origin without credentials, a path, or query parameters.'
    return 1
  fi
}

current_main_sha() {
  local response
  if ! response=$(curl --fail --silent --show-error --connect-timeout 10 --max-time 30 \
    --header "Authorization: Bearer $GITHUB_TOKEN" \
    --header 'Accept: application/vnd.github+json' \
    --header 'X-GitHub-Api-Version: 2022-11-28' \
    "${GITHUB_API_URL:-https://api.github.com}/repos/$GITHUB_REPOSITORY/git/ref/heads/main"); then
    deployment_error 'Cannot check the current main commit; no upload was started.'
    return 1
  fi
  if ! jq -er '.object.sha | select(type == "string" and test("^[0-9a-f]{40}$"))' <<< "$response"; then
    deployment_error 'GitHub returned an invalid main commit; no upload was started.'
    return 1
  fi
}

wait_for_deployment() {
  local deployment_id=$1 response status deadline remaining
  if ! command -v timeout >/dev/null 2>&1; then
    deployment_error 'GNU timeout is required (included on the GitHub Actions Linux runner).'
    return 1
  fi
  deadline=$(( $(date +%s) + 1200 ))
  while (( $(date +%s) < deadline )); do
    remaining=$((deadline - $(date +%s)))
    if (( remaining <= 0 )); then
      break
    fi
    if ! response=$(timeout --signal=TERM --kill-after=5s "${remaining}s" railway deployment list \
      --project "$PROJECT_ID" --environment "$ENVIRONMENT_ID" --service "$SERVICE_ID" \
      --limit 100 --json); then
      deployment_error "Cannot read the status of deployment $deployment_id."
      return 1
    fi
    if ! status=$(jq -er --arg id "$deployment_id" '
      if type != "array" then error("Expected a deployment array") else
        [.[] | select(.id == $id)] |
        if length == 0 then "PENDING_VISIBILITY"
        elif length != 1 then error("Duplicate deployment ID")
        else .[0].status | if type == "string" then . else error("Missing deployment status") end
        end
      end' <<< "$response"); then
      deployment_error 'Railway returned an invalid deployment status response.'
      return 1
    fi
    printf 'Deployment %s: %s\n' "$deployment_id" "$status"
    case "$status" in
      SUCCESS) return 0 ;;
      BUILDING|DEPLOYING|INITIALIZING|QUEUED|WAITING|PENDING_VISIBILITY) ;;
      *)
        deployment_error "Deployment $deployment_id did not succeed ($status)."
        return 1
        ;;
    esac
    remaining=$((deadline - $(date +%s)))
    if (( remaining <= 0 )); then
      break
    elif (( remaining < 10 )); then
      sleep "$remaining"
    else
      sleep 10
    fi
  done
  deployment_error "Timed out after 20 minutes waiting for deployment $deployment_id."
  return 1
}

deploy_railway() {
  local main_sha response deployment_id script_dir
  validate_deployment_environment || return 1
  if [[ "$(railway --version)" != 'railway 5.59.0' ]]; then
    deployment_error 'Expected Railway CLI 5.59.0.'
    return 1
  fi
  main_sha=$(current_main_sha) || return 1
  if [[ "$main_sha" != "$GITHUB_SHA" ]]; then
    printf 'Skipping commit %s: main is now %s.\n' "$GITHUB_SHA" "$main_sha"
    if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
      printf 'Skipped obsolete commit `%s`; main is now `%s`.\n' "$GITHUB_SHA" "$main_sha" >> "$GITHUB_STEP_SUMMARY"
    fi
    return 0
  fi
  if ! response=$(railway up \
    --project "$PROJECT_ID" --environment "$ENVIRONMENT_ID" --service "$SERVICE_ID" \
    --detach --json --message "$GITHUB_SHA"); then
    deployment_error 'Railway upload failed.'
    return 1
  fi
  if ! deployment_id=$(jq -er '.deploymentId | select(type == "string" and test("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"))' <<< "$response"); then
    deployment_error 'Railway did not return a valid deployment ID.'
    return 1
  fi
  printf 'Uploaded commit %s as deployment %s.\n' "$GITHUB_SHA" "$deployment_id"
  if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    printf 'Commit: `%s`\n\nRailway deployment: `%s`\n' "$GITHUB_SHA" "$deployment_id" >> "$GITHUB_STEP_SUMMARY"
  fi
  wait_for_deployment "$deployment_id" || return 1
  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
  bash "$script_dir/smoke-http.sh" "$APP_URL" || return 1
  if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    printf '\nDeployment reached SUCCESS and public HTTP checks passed: %s\n' "$APP_URL" >> "$GITHUB_STEP_SUMMARY"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  deploy_railway
fi
