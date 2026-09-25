#!/usr/bin/env bash
# renovate-local.sh - which of this package's dependencies are behind, decided
# by Renovate run as a LOCAL CLI. This is the ONLY way this repository's
# .github/renovate.json is ever read: the Renovate GitHub App is installed on no
# repo in this family and will not be (owner decision, 2026-09-09), and no
# workflow runs this file. It is not a gate and blocks no commit.
#
#     bash scripts/linux/renovate-local.sh                 # report (default)
#     bash scripts/linux/renovate-local.sh --hub ../ANTfrastructure
#     bash scripts/linux/renovate-local.sh --managers pub  # narrow it
#     bash scripts/linux/renovate-local.sh --print-bin     # resolved renovate.js
#
# WHY THIS FILE LOOKS DIFFERENT FROM EVERY OTHER WRAPPER IN THE FAMILY, and why
# it exists at all.
#
# The other consumers each keep a two-line wrapper that sources the canonical
# bootstrap (ANTfrastructure shared/linux/templates/antfrastructure.sh) and execs
# the hub driver. That bootstrap resolves the hub at
# <repo>/third_party/ANTfrastructure and, when it is missing, tells the reader to
# run `git submodule update --init --recursive third_party/ANTfrastructure`.
# ANThology has no .gitmodules at all - docs.yml checks the shared tooling out in
# CI instead - so that path can never exist here and that instruction would be a
# lie. The lint job in .github/workflows/docs.yml records exactly this and
# concludes, correctly for THAT gate, that a wrapper would have nothing left to
# wrap: the lane already calls the hub runner directly.
#
# The Renovate case is not that case, and the difference is the whole reason this
# file exists: NO lane runs Renovate here, in CI or anywhere else. Without a
# local entry point this repository has no dependency watch whatsoever - only a
# config file nothing reads. So the wrapper is worth having, and the one thing it
# must do that the others get for free is FIND the hub. That ladder is not here
# either: it is scripts/lib/find-hub.sh, shared with scripts/run-dart-checks.sh,
# whose header carries the probe order and what each rung is for.
#
# WHY NOT JUST ADD THE SUBMODULE. That would make this repo a copy of the other
# consumers and delete this header - genuinely tempting. It loses on two counts.
# It reverses a standing decision this repository has already written down twice
# (docs.yml checks the hub out at a floating `ref: develop` on purpose, and
# .github/renovate.json explains that the preset deliberately leaves the
# Kataglyphis composite actions at @develop so tooling and actions move together);
# a gitlink would pin what those lanes have decided to float. And it is a change
# to the repository's shape, made to reach a report-only tool, in a pure Dart
# package that has never had a third_party/ directory.
#
# WHY NOT LEAVE IT DOCUMENTED-ONLY, i.e. "clone the hub and call it yourself".
# That is what the lint job does for the gates, and there the CI lane is the real
# entry point with the local run as a fallback. Here there is no lane, so
# "documented only" means the tool is reachable exactly as often as somebody
# retypes a path correctly.
#
# THE ACTIONS HALF NEEDS A TOKEN, AND SAYS SO. Without one Renovate warns that
# the GitHub dependencies went ungraded and reports the pub side only - that
# warning is the answer being INCOMPLETE, not noise to scroll past. Use
# GITHUB_COM_TOKEN, which is the variable `--platform=local` actually reads:
#
#   GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/linux/renovate-local.sh
#
# The hub page names RENOVATE_TOKEN; its token paragraph is where that
# difference, the measurement behind it and the digest pins the actions half
# produces are written down. Read it there rather than here:
# https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/dependency-updates.md
#
# APPLY IS NOT AVAILABLE HERE AND THAT IS NOT A BUG. Renovate's --platform=local
# forces dryRun - it DETECTS and never edits a file - and upstream's --apply half
# is git moving submodule gitlinks. With no .gitmodules it prints "no .gitmodules
# in <root>; nothing to apply". pubspec.yaml stays yours to edit, with
# .github/dependabot.yml still covering the pub ecosystem on GitHub's side.
#
# ON A WINDOWS HOST, RUN IT FROM WSL: the hub bootstraps a pinned,
# checksum-verified Node and Renovate into ~/.cache, and there is no node on the
# Windows side. The report half only reads, so it is safe from anywhere.
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

# exec, so the driver's exit status is this script's with no intermediate shell
# to lose it - the same reason the family's antfrastructure_exec uses it. What is
# NOT copied from that helper is its WORKSPACE_ROOT export: this driver never
# reads it. The repo root travels as the explicit argument below instead, since
# upstream would otherwise default its target to $PWD and grade whatever
# directory the caller happened to be standing in.
exec bash "${ANTFRASTRUCTURE_DIR}/${HUB_DRIVER_RELATIVE}" \
  "${KATAGLYPHIS_REPO_ROOT}" \
  ${FORWARD[@]+"${FORWARD[@]}"}
