#!/usr/bin/env bash
# run-dart-checks.sh [--test-platform vm|chrome] - the Dart gate (pub get, format on tracked files, analyze, test) as one command for CI and dev box.
set -euo pipefail

_RUN_DART_CHECKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/find-hub.sh
source "${_RUN_DART_CHECKS_DIR}/lib/find-hub.sh"

DART_GATE_RELATIVE="linux/scripts/05-frameworks/flutter/flutter_checks.sh"

# Only the test platform: --strict false would turn the blocking gate into a warning; pick a hub with ANTFRASTRUCTURE_DIR.
TEST_PLATFORM="vm"
if [ "$#" -eq 2 ] && [ "$1" = "--test-platform" ]; then
  TEST_PLATFORM="$2"
elif [ "$#" -gt 0 ]; then
  echo "run-dart-checks.sh: takes only --test-platform <vm|chrome> (got: $*)." >&2
  echo "       For other knobs call ANTfrastructure's flutter_checks.sh directly," >&2
  echo "       and set ANTFRASTRUCTURE_DIR to choose the checkout it comes from." >&2
  exit 2
fi

antfrastructure_find_hub "${DART_GATE_RELATIVE}" "run-dart-checks.sh" 0 ""

# flutter_checks.sh works relative to the cwd.
cd "${KATAGLYPHIS_REPO_ROOT}"

# exec keeps the gate's exit status.
exec bash "${ANTFRASTRUCTURE_DIR}/${DART_GATE_RELATIVE}" --strict true --test-platform "${TEST_PLATFORM}"
