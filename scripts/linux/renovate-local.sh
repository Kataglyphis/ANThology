#!/usr/bin/env bash
# renovate-local.sh - Renovate as a local CLI, the only watch over the actions since no lane runs it; run from WSL.
set -euo pipefail

HUB_DRIVER_RELATIVE="linux/scripts/renovate-local.sh"

_RENOVATE_LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The hub lookup ladder, and KATAGLYPHIS_REPO_ROOT with it.
# shellcheck source=/dev/null
source "${_RENOVATE_LOCAL_DIR}/../lib/find-hub.sh"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/linux/renovate-local.sh [--hub <ANTfrastructure checkout>] [options]

Reports which of this repo's dependencies are behind, per .github/renovate.json.
ANTfrastructure detects the managers from what the tree has; --managers narrows that.

  --hub <dir>       where ANTfrastructure is checked out. Also read from
                    $ANTFRASTRUCTURE_DIR; otherwise probed, in the order
                    scripts/lib/find-hub.sh documents.
  --managers <csv>  run only these Renovate managers
  --refresh         drop the lookup cache before running
  --print-bin       print the resolved renovate.js and exit

Every option other than --hub is passed straight through to ANTfrastructure's
linux/scripts/renovate-local.sh. Do not pass a repo root: this wrapper supplies
it, and upstream refuses a second one.

Live runs fail before scanning if no GitHub token is available. Authenticate gh or supply one:
  GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/linux/renovate-local.sh
EOF
}

HUB_EXPLICIT=""
HUB_EXPLICIT_SET=0
FORWARD=()
while [ $# -gt 0 ]; do
  case "$1" in
    --hub)
      shift
      [ $# -gt 0 ] || { echo "renovate-local.sh: --hub needs a directory" >&2; exit 1; }
      HUB_EXPLICIT="$1"; HUB_EXPLICIT_SET=1
      ;;
    --hub=*)
      HUB_EXPLICIT="${1#*=}"; HUB_EXPLICIT_SET=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      FORWARD+=("$1")
      ;;
  esac
  shift
done

if [ "${HUB_EXPLICIT_SET}" -eq 0 ] && [ -z "${ANTFRASTRUCTURE_DIR:-}" ]; then
  antfrastructure_hub_candidates
  _HUB_FOUND=0
  for _candidate in "${ANTFRASTRUCTURE_HUB_CANDIDATES[@]}"; do
    if antfrastructure_hub_holds "${_candidate}" "${HUB_DRIVER_RELATIVE}"; then
      _HUB_FOUND=1
      break
    fi
  done
  if [ "${_HUB_FOUND}" -eq 0 ] && (
    source "${_RENOVATE_LOCAL_DIR}/../lib/antfrastructure.sh"
    antfrastructure_renovate_will_apply "${FORWARD[@]}"
  ); then
    # This copy exists so a real apply can initialize a missing pinned hub.
    source "${_RENOVATE_LOCAL_DIR}/../lib/antfrastructure.sh"
    if antfrastructure_renovate_exec "${HUB_DRIVER_RELATIVE}" "${KATAGLYPHIS_REPO_ROOT}" "${FORWARD[@]}"; then
      exit 0
    else
      exit $?
    fi
  fi
fi

antfrastructure_find_hub "${HUB_DRIVER_RELATIVE}" "renovate-local.sh" \
  "${HUB_EXPLICIT_SET}" "${HUB_EXPLICIT}"

# exec keeps the driver's exit status; the root is explicit, or upstream would grade $PWD.
exec bash "${ANTFRASTRUCTURE_DIR}/${HUB_DRIVER_RELATIVE}" \
  "${KATAGLYPHIS_REPO_ROOT}" \
  ${FORWARD[@]+"${FORWARD[@]}"}
