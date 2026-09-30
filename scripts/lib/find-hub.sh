#!/usr/bin/env bash
# find-hub.sh - sourced, never run: finds an ANTfrastructure checkout, since this repo has no submodule.

_ANTHOLOGY_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Overridable: a container mounts the workspace at a different path than the host.
KATAGLYPHIS_REPO_ROOT="${KATAGLYPHIS_REPO_ROOT:-$(cd "${_ANTHOLOGY_LIB_DIR}/../.." && pwd)}"

# The marker file must be inside: a half-finished clone or stale path would otherwise fail later, unexplained.
antfrastructure_hub_holds() {
  if [ -n "${1:-}" ] && [ -n "${2:-}" ] && [ -f "${1}/${2}" ]; then
    return 0
  fi
  return 1
}

# antfrastructure_find_hub <marker> <label> <explicit-set> <explicit-dir> - sets ANTFRASTRUCTURE_DIR; an explicit (even empty) path is never probed past.
antfrastructure_find_hub() {
  local marker="${1:?antfrastructure_find_hub: marker path required}"
  local label="${2:?antfrastructure_find_hub: caller label required}"
  local explicit_set="${3:-0}"
  local explicit="${4:-}"
  local named candidate

  if [ "${explicit_set}" = 1 ] && [ -z "${explicit}" ]; then
    echo "${label}: --hub was given an empty value." >&2
    echo "       That is not the same as omitting it: omitting --hub lets this" >&2
    echo "       script search, while an empty one names nothing at all." >&2
    return 1
  fi

  ANTFRASTRUCTURE_HUB_CANDIDATES=(
    "${KATAGLYPHIS_REPO_ROOT}/antfrastructure-tools"
    "${KATAGLYPHIS_REPO_ROOT}/third_party/ANTfrastructure"
    "${KATAGLYPHIS_REPO_ROOT}/../ANTfrastructure"
    "${KATAGLYPHIS_REPO_ROOT}/../../ANTfrastructure"
  )

  for named in "${explicit}" "${ANTFRASTRUCTURE_DIR:-}"; do
    [ -n "${named}" ] || continue
    if ! antfrastructure_hub_holds "${named}" "${marker}"; then
      echo "${label}: ${named} does not hold ${marker}." >&2
      echo "       That path was given explicitly (--hub or ANTFRASTRUCTURE_DIR), so it" >&2
      echo "       is an error rather than something to probe past. Either point it at" >&2
      echo "       an ANTfrastructure checkout, or unset it to let this script search." >&2
      return 1
    fi
    ANTFRASTRUCTURE_DIR="$(cd "${named}" && pwd)"
    export ANTFRASTRUCTURE_DIR
    return 0
  done

  for candidate in "${ANTFRASTRUCTURE_HUB_CANDIDATES[@]}"; do
    if antfrastructure_hub_holds "${candidate}" "${marker}"; then
      ANTFRASTRUCTURE_DIR="$(cd "${candidate}" && pwd)"
      export ANTFRASTRUCTURE_DIR
      return 0
    fi
  done

  antfrastructure_hub_not_found "${marker}" "${label}"
  return 1
}

# Never a bare "command not found": name every probed path and the fix.
antfrastructure_hub_not_found() {
  local candidate
  echo "${2}: no ANTfrastructure checkout holding ${1}." >&2
  echo "" >&2
  echo "This repository has no ANTfrastructure submodule - by decision, not by" >&2
  echo "omission - so the hub has to be found rather than assumed. Probed:" >&2
  for candidate in "${ANTFRASTRUCTURE_HUB_CANDIDATES[@]}"; do
    echo "  ${candidate}" >&2
  done
  echo "" >&2
  echo "Fix it either way:" >&2
  echo "  git clone --depth 1 https://github.com/Kataglyphis/ANTfrastructure" >&2
  echo "  export ANTFRASTRUCTURE_DIR=\"\${PWD}/ANTfrastructure\"" >&2
  echo "or pass --hub <checkout> to the wrapper that takes it (renovate-local.sh)." >&2
  echo "" >&2
  echo "A checkout that IS there but too old is a different failure: it holds the" >&2
  echo "directory and not the file above, and lands here too. Pull it." >&2
  return 0
}
