#!/usr/bin/env bash
# build-docs.sh - the docs site (dart doc, the family theme, the docs/ guides) into doc/api; what docs.yml's docs job runs.
set -euo pipefail

_BUILD_DOCS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/find-hub.sh
source "${_BUILD_DOCS_DIR}/lib/find-hub.sh"

DARTDOC_LIB_RELATIVE="linux/scripts/lib/dartdoc-build.sh"

if [ "$#" -gt 0 ]; then
  echo "build-docs.sh: takes no arguments (got: $*)." >&2
  exit 2
fi

antfrastructure_find_hub "${DARTDOC_LIB_RELATIVE}" "build-docs.sh" 0 ""

# dartdoc_build_main works relative to the cwd.
cd "${KATAGLYPHIS_REPO_ROOT}"
# dart doc writes over doc/api without clearing it, so a staged .htaccess or a deleted page would survive a rebuild.
rm -rf doc/api

# The hub's builder: dartdoc set-up, plus the guide list that builder cannot take.
DARTDOC_BUILD_THEME_CSS="${ANTFRASTRUCTURE_DIR}/third_party/DocumANTation/style/dartdoc.css"
DARTDOC_BUILD_IMAGES_DIR="${KATAGLYPHIS_REPO_ROOT}/images"
# Not the checkout's origin: a submodule checkout mounted on its own has no readable .git.
DARTDOC_BUILD_REPO_URL="https://github.com/Kataglyphis/ANThology"
export DARTDOC_BUILD_THEME_CSS DARTDOC_BUILD_IMAGES_DIR DARTDOC_BUILD_REPO_URL
# shellcheck disable=SC2034 # read by dartdoc_build_generate
DARTDOC_BUILD_CLEAN_CMD=(flutter pub get)
# <source>|<slug>|<nav title>; the slug names guide-<slug>.html, so renaming one moves a URL.
# shellcheck disable=SC2034 # read by dartdoc_build_stage_guides and dartdoc_build_render_guides
DARTDOC_BUILD_GUIDES=(
  "${KATAGLYPHIS_REPO_ROOT}/docs/getting-started.md|getting-started|Getting started"
)

# shellcheck source=/dev/null
source "${ANTFRASTRUCTURE_DIR}/${DARTDOC_LIB_RELATIVE}"
dartdoc_build_main
