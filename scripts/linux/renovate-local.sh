#!/usr/bin/env bash
# renovate-local.sh - Renovate as a local CLI, this repo's only dependency watch since no lane runs it; run from WSL.
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

The github-actions half is incomplete without a token and warns when it is:
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

antfrastructure_find_hub "${HUB_DRIVER_RELATIVE}" "renovate-local.sh" \
  "${HUB_EXPLICIT_SET}" "${HUB_EXPLICIT}"

# exec keeps the driver's exit status; the root is explicit, or upstream would grade $PWD.
exec bash "${ANTFRASTRUCTURE_DIR}/${HUB_DRIVER_RELATIVE}" \
  "${KATAGLYPHIS_REPO_ROOT}" \
  ${FORWARD[@]+"${FORWARD[@]}"}
