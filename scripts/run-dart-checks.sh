#!/usr/bin/env bash
# run-dart-checks.sh - this repository's Dart gate as ONE command that CI and a
# dev box both run: pub get, format over TRACKED files, analyze, test.
#
# .github/workflows/docs.yml used to spell the hub script and its --strict flag
# out inline, which left the gate with no local entry point at all: reproducing
# it meant retyping a path into antfrastructure-tools/ that exists only on a
# runner. The hub lookup is scripts/lib/find-hub.sh, shared with the Renovate
# wrapper; the gate itself stays ANTfrastructure's, so `dart format` keeps
# enumerating tracked files rather than walking the tree.
set -euo pipefail

_RUN_DART_CHECKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/find-hub.sh
source "${_RUN_DART_CHECKS_DIR}/lib/find-hub.sh"

DART_GATE_RELATIVE="linux/scripts/05-frameworks/flutter/flutter_checks.sh"

# No pass-through, and no --hub either. This is the BLOCKING gate: it is fixed
# at --strict true, because the one knob a caller would reach for (--strict
# false) turns it into a warning, and silently dropping an argument is worse
# than refusing it. Point it at a hub with ANTFRASTRUCTURE_DIR=<checkout>, which
# find-hub.sh honours ahead of everything it probes.
if [ "$#" -gt 0 ]; then
  echo "run-dart-checks.sh: takes no arguments (got: $*)." >&2
  echo "       For other knobs call ANTfrastructure's flutter_checks.sh directly," >&2
  echo "       and set ANTFRASTRUCTURE_DIR to choose the checkout it comes from." >&2
  exit 2
fi

antfrastructure_find_hub "${DART_GATE_RELATIVE}" "run-dart-checks.sh" 0 ""

# flutter_checks.sh resolves dependencies and enumerates Dart files relative to
# the cwd, so run from the repo root whatever directory the caller was in.
cd "${KATAGLYPHIS_REPO_ROOT}"

# exec, so the gate's exit status is this script's with no intermediate shell to
# lose it - the same reason the family's antfrastructure_exec uses it.
exec bash "${ANTFRASTRUCTURE_DIR}/${DART_GATE_RELATIVE}" --strict true
