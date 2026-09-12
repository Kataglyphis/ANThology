#!/usr/bin/env bash
# renovate-local.sh - which of this package's dependencies are behind, decided
# by Renovate run as a LOCAL CLI. This is the ONLY way this repository's
# .github/renovate.json is ever read: the Renovate GitHub App is installed on no
# repo in this family and will not be (owner decision, 2026-09-09), and no
# workflow runs this file. It is not a gate and blocks no commit.
#
#     bash scripts/renovate-local.sh                      # report (default)
#     bash scripts/renovate-local.sh --hub ../ANTfrastructure
#     bash scripts/renovate-local.sh --managers pub       # narrow it
#     bash scripts/renovate-local.sh --print-bin          # resolved renovate.js
#
# WHY THIS FILE LOOKS DIFFERENT FROM EVERY OTHER WRAPPER IN THE FAMILY, and why
# it exists at all.
#
# The other five consumers each keep a two-line wrapper that sources the
# canonical bootstrap (ANTfrastructure shared/linux/templates/antfrastructure.sh) and
# execs the hub driver. That bootstrap resolves the hub at
# <repo>/third_party/ANTfrastructure and, when it is missing, tells the reader to
# run `git submodule update --init --recursive third_party/ANTfrastructure`.
# ANThology has no .gitmodules at all - dart.yml and lint-gates.yml check the
# shared tooling out in CI instead - so that path can never exist here and that
# instruction would be a lie. .github/workflows/lint-gates.yml records exactly
# this and concludes, correctly for THAT gate, that a wrapper would have nothing
# left to wrap: the CI lane already calls the hub runner directly, and the local
# equivalent is a clone plus one command.
#
# The Renovate case is not that case, and the difference is the whole reason
# this file exists: NO lane runs Renovate here, in CI or anywhere else. Without
# a local entry point this repository has no dependency watch whatsoever - only
# a config file nothing reads. So the wrapper is worth having, and the one thing
# it must do that the others get for free is FIND the hub.
#
# HOW IT FINDS ONE, in order, each candidate accepted only if it actually holds
# linux/scripts/renovate-local.sh:
#
#   1. --hub <dir>            an explicit answer, and a hard error if it is wrong
#   2. $ANTFRASTRUCTURE_DIR      the same variable the family bootstrap exports, so
#                             a shell already set up for a sibling repo works here
#   3. ./antfrastructure-tools   what dart.yml and lint-gates.yml create in CI, so
#                             the identical command works on a runner
#   4. ./third_party/ANTfrastructure   if this repo ever grows the submodule
#   5. ../ANTfrastructure, ../../ANTfrastructure   a checkout beside this one - the
#                             shape on a dev box where ANThology sits in
#                             OmniAccelerANT/third_party/ next to the hub
#
# When none of them holds the driver this prints every path it probed and the
# two ways to fix it. It must never fail as a bare "command not found" or run
# something out of an empty path - that is the whole contract of a wrapper that
# cannot rely on a submodule.
#
# WHY NOT JUST ADD THE SUBMODULE. That would make this repo a copy of the other
# five and delete this header - genuinely tempting. It loses on two counts. It
# reverses a standing decision this repository has already written down twice
# (dart.yml and lint-gates.yml both check the hub out at a floating `ref: main`
# on purpose, and .github/renovate.json explains that the preset deliberately
# leaves the Kataglyphis composite actions at @main so tooling and actions move
# together); a gitlink would pin what those lanes have decided to float. And it
# is a change to the repository's shape, made to reach a report-only tool, in a
# pure Dart package that has never had a third_party/ directory. If ANThology
# ever grows the submodule for a real reason, candidate 4 above finds it and
# this file keeps working unchanged.
#
# WHY NOT LEAVE IT DOCUMENTED-ONLY, i.e. "clone the hub and call it yourself".
# That is what lint-gates.yml does for the gates, and there the CI lane is the
# real entry point with the local run as a fallback. Here there is no lane, so
# "documented only" means the tool is reachable exactly as often as somebody
# retypes a path correctly.
#
# THE DEFAULT MANAGER SET IS THIS REPO'S, NOT THE FAMILY'S. Upstream defaults to
# `--managers git-submodules`, which is the right answer in the five repos that
# have gitlinks and a meaningless one here: it would report "up to date -
# nothing behind for manager(s) git-submodules" over a repo with no submodules,
# which reads like an all-clear and is really an empty question. This repo's
# dependency surface is pubspec.yaml and the pinned actions in .github/workflows,
# so that is what is asked by default. A --managers of your own is passed after
# this one and wins.
#
# Both halves of that were measured here on 2026-09-09, from WSL:
# `--managers git-submodules` printed "up to date: nothing behind for manager(s)
# git-submodules" over a repo that has no submodules, while the default set
# found go_router ^17.2.1 -> ^18.0.0 in pubspec.yaml.
#
# THE ACTIONS HALF NEEDS A TOKEN, AND SAYS SO. Without one Renovate prints
#
#   WARN: GitHub token is required for some dependencies
#         "githubDeps": ["actions/checkout", "SamKirkland/FTP-Deploy-Action"]
#
# and reports the pub side only. That warning is the answer being INCOMPLETE, not
# noise to scroll past. Measured 2026-09-09, three ways, from WSL:
#
#   no token                        1 row  (go_router ^17.2.1 -> ^18.0.0)
#   RENOVATE_TOKEN only             1 row  - same warning, unchanged
#   GITHUB_COM_TOKEN                5 rows - warning gone, actions/checkout
#                                   v6.0.0 -> d23441a48e51 and
#                                   SamKirkland/FTP-Deploy-Action v4.3.6 ->
#                                   110f9186c050 (digest pins, which is what
#                                   helpers:pinGitHubActionDigests is for)
#
# So use GITHUB_COM_TOKEN. The hub's docs/dependency-updates.md names
# RENOVATE_TOKEN for this; under `--platform=local` that is not the variable
# Renovate reads, and the run above is what proves it.
#
#   GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/renovate-local.sh
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
#
# Rationale, the version pins and the full-fidelity `--platform=github` variant
# live in the hub's own tree: docs/dependency-updates.md. Read its token
# paragraph against the measurement above.
set -euo pipefail

HUB_DRIVER_RELATIVE="linux/scripts/renovate-local.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Overridable for the same reason the family bootstrap makes it overridable: in
# a container the workspace is mounted at a different path than on the host.
KATAGLYPHIS_REPO_ROOT="${KATAGLYPHIS_REPO_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

usage() {
  cat <<'EOF'
Usage:
  bash scripts/renovate-local.sh [--hub <ANTfrastructure checkout>] [options]

Reports which of this repo's dependencies are behind, per .github/renovate.json.
Defaults to --managers github-actions,pub; pass your own --managers to override.

  --hub <dir>       where ANTfrastructure is checked out. Also read from
                    $ANTFRASTRUCTURE_DIR; otherwise probed (see the header).
  --managers <csv>  which Renovate managers to run
  --refresh         drop the lookup cache before running
  --print-bin       print the resolved renovate.js and exit

Every option other than --hub is passed straight through to ANTfrastructure's
linux/scripts/renovate-local.sh. Do not pass a repo root: this wrapper supplies
it, and upstream refuses a second one.

The github-actions half is incomplete without a token and warns when it is:
  GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/renovate-local.sh
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

# A candidate counts only if the driver is actually in it. "The directory
# exists" is not the same question: a half-finished clone, or a path that used
# to hold the hub, would otherwise be accepted and fail later inside bash with a
# message naming neither this wrapper nor the reason.
hub_holds_driver() {
  [ -n "${1:-}" ] && [ -f "${1}/${HUB_DRIVER_RELATIVE}" ]
}

# An answer somebody gave explicitly is never silently discarded: if --hub or
# ANTFRASTRUCTURE_DIR is wrong, say so about THAT path rather than quietly probing
# on and reporting against a different hub than the one that was asked for.
ANTFRASTRUCTURE_DIR_RESOLVED=""
# An EXPLICIT empty value is an error, not an absence: `--hub ""` reached the
# `[ -n ]` skip below and resolved a completely different hub while the header
# promised "an answer somebody gave explicitly is never silently discarded".
if [ "${HUB_EXPLICIT_SET}" = 1 ] && [ -z "${HUB_EXPLICIT}" ]; then
  echo "renovate-local.sh: --hub was given an empty value." >&2
  echo "       That is not the same as omitting it: omitting --hub lets this" >&2
  echo "       script search, while an empty one names nothing at all." >&2
  exit 1
fi
for _named in "${HUB_EXPLICIT}" "${ANTFRASTRUCTURE_DIR:-}"; do
  [ -n "${_named}" ] || continue
  if ! hub_holds_driver "${_named}"; then
    echo "renovate-local.sh: ${_named} does not hold ${HUB_DRIVER_RELATIVE}." >&2
    echo "       That path was given explicitly (--hub or ANTFRASTRUCTURE_DIR), so it is" >&2
    echo "       an error rather than something to probe past. Either point it at a" >&2
    echo "       ANTfrastructure checkout, or unset it to let this script search." >&2
    exit 1
  fi
  ANTFRASTRUCTURE_DIR_RESOLVED="$(cd "${_named}" && pwd)"
  break
done

CANDIDATES=(
  "${KATAGLYPHIS_REPO_ROOT}/antfrastructure-tools"
  "${KATAGLYPHIS_REPO_ROOT}/third_party/ANTfrastructure"
  "${KATAGLYPHIS_REPO_ROOT}/../ANTfrastructure"
  "${KATAGLYPHIS_REPO_ROOT}/../../ANTfrastructure"
)

if [ -z "${ANTFRASTRUCTURE_DIR_RESOLVED}" ]; then
  for _candidate in "${CANDIDATES[@]}"; do
    if hub_holds_driver "${_candidate}"; then
      ANTFRASTRUCTURE_DIR_RESOLVED="$(cd "${_candidate}" && pwd)"
      break
    fi
  done
fi

if [ -z "${ANTFRASTRUCTURE_DIR_RESOLVED}" ]; then
  echo "renovate-local.sh: no ANTfrastructure checkout holding ${HUB_DRIVER_RELATIVE}." >&2
  echo "" >&2
  echo "This repository has no ANTfrastructure submodule - by decision, not by" >&2
  echo "omission - so the hub has to be found rather than assumed. Probed:" >&2
  for _candidate in "${CANDIDATES[@]}"; do
    echo "  ${_candidate}" >&2
  done
  echo "" >&2
  echo "Fix it either way:" >&2
  echo "  git clone --depth 1 https://github.com/Kataglyphis/ANTfrastructure" >&2
  echo "  bash scripts/renovate-local.sh --hub ./ANTfrastructure" >&2
  echo "or export ANTFRASTRUCTURE_DIR=<checkout> once for the shell." >&2
  echo "" >&2
  echo "A checkout that IS there but too old is a different failure: it will hold" >&2
  echo "the directory and not the driver, and lands here too. Pull it." >&2
  exit 1
fi

export ANTFRASTRUCTURE_DIR="${ANTFRASTRUCTURE_DIR_RESOLVED}"

# exec, so the driver's exit status is this script's with no intermediate shell
# to lose it - the same reason the family's antfrastructure_exec uses it. What is
# NOT copied from that helper is its WORKSPACE_ROOT export: this driver never
# reads it. The repo root travels as the explicit argument below instead, since
# upstream would otherwise default its target to $PWD and grade whatever
# directory the caller happened to be standing in.
exec bash "${ANTFRASTRUCTURE_DIR}/${HUB_DRIVER_RELATIVE}" \
  --managers github-actions,pub \
  "${KATAGLYPHIS_REPO_ROOT}" \
  ${FORWARD[@]+"${FORWARD[@]}"}
