#!/usr/bin/env bash
# find-hub.sh - where this repository's wrappers find an ANTfrastructure
# checkout. SOURCED, never executed: it publishes KATAGLYPHIS_REPO_ROOT and
# defines antfrastructure_find_hub, which puts its answer in ANTFRASTRUCTURE_DIR.
#
# It exists because ANThology has no third_party/ANTfrastructure and no
# .gitmodules - a decision, not an omission, whose owners are the headers of
# scripts/linux/renovate-local.sh and .github/workflows/dart.yml. The family
# bootstrap (ANTfrastructure shared/linux/templates/antfrastructure.sh) resolves
# the hub at <repo>/third_party/ANTfrastructure and tells a reader who has none
# to run `git submodule update --init`, which here would be a lie. So the hub is
# FOUND rather than assumed - and the ladder lives in one file instead of being
# retyped by every wrapper that needs it.

_ANTHOLOGY_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Overridable for the same reason the family bootstrap makes it overridable: in
# a container the workspace is mounted at a different path than on the host.
KATAGLYPHIS_REPO_ROOT="${KATAGLYPHIS_REPO_ROOT:-$(cd "${_ANTHOLOGY_LIB_DIR}/../.." && pwd)}"

# A candidate counts only if the marker file is actually inside it. "The
# directory exists" is a different question: a half-finished clone, or a path
# that used to hold the hub, would otherwise be accepted here and fail later
# inside bash with a message naming neither this wrapper nor the reason.
antfrastructure_hub_holds() {
  if [ -n "${1:-}" ] && [ -n "${2:-}" ] && [ -f "${1}/${2}" ]; then
    return 0
  fi
  return 1
}

# antfrastructure_find_hub <marker-relative-path> <caller-label> <explicit-set>
#                          <explicit-dir>
#
# Resolves a checkout that really holds <marker-relative-path> and publishes it
# as ANTFRASTRUCTURE_DIR. The order, and the reason for each rung:
#
#   1. the explicit answer      --hub, or whatever the caller parsed
#   2. $ANTFRASTRUCTURE_DIR     the variable the family bootstrap exports, so a
#                               shell set up for a sibling repo works here
#   3. ./antfrastructure-tools  what dart.yml creates in CI, so the identical
#                               command works unchanged on a runner
#   4. ./third_party/ANTfrastructure   if this repo ever grows the submodule
#   5. ../ANTfrastructure, ../../ANTfrastructure   a checkout beside this one -
#                               the dev-box shape, ANThology sitting in
#                               OmniAccelerANT/third_party/ next to the hub
#
# An answer somebody gave EXPLICITLY is never silently discarded: a wrong --hub
# or ANTFRASTRUCTURE_DIR is an error about THAT path rather than something to
# probe past and then report against a different hub than the one asked for.
# <explicit-set> is separate from <explicit-dir> because an explicitly EMPTY
# value is an error too: `--hub ""` names nothing at all, which is not the same
# as omitting the flag and letting this function search.
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

# The not-found report, kept whole: it must never fail as a bare "command not
# found" or run something out of an empty path - that is the entire contract of
# a wrapper that cannot rely on a submodule.
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
