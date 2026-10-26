#!/usr/bin/env bash
# A local Git fixture proves the custom hub lookup and first apply without running Renovate.
set -u
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=third_party/ANTfrastructure/linux/scripts/tests/renovate-bootstrap-fixture.sh
source "${REPO_ROOT}/third_party/ANTfrastructure/linux/scripts/tests/renovate-bootstrap-fixture.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

_anthology_seed() {
  local seed="$1"
  t_renovate_bootstrap_driver "${seed}" <<'SH' || return 1
#!/usr/bin/env bash
printf 'pinned\n%s\n' "$*" > "${DRIVER_ARGS:?}"
exit "${DRIVER_EXIT:-0}"
SH
}

_anthology_consumer() {
  local repo="$1"
  mkdir -p "${repo}/scripts/linux" "${repo}/scripts/lib" || return 1
  cp "${REPO_ROOT}/scripts/linux/renovate-local.sh" "${repo}/scripts/linux/" || return 1
  cp "${REPO_ROOT}/scripts/lib/find-hub.sh" "${REPO_ROOT}/scripts/lib/antfrastructure.sh" \
    "${REPO_ROOT}/scripts/lib/renovate-git-mode.sh" "${repo}/scripts/lib/"
}

make_fixture() { t_renovate_bootstrap_fixture "${WORK}/$1" _anthology_seed _anthology_consumer; }

run_wrapper() {
  local repo="$1"
  shift
  (
    unset ANTFRASTRUCTURE_DIR KATAGLYPHIS_REPO_ROOT
    t_renovate_bootstrap_run "${repo}" "${WORK}" "$@"
  )
}

t_case "report, dry-run and help do not initialize a missing pinned hub"
repo="$(make_fixture preview)" || exit 1
t_assert_rc 0 run_wrapper "${repo}" --help
t_assert_fails run_wrapper "${repo}"
t_assert_fails run_wrapper "${repo}" --apply --dry-run
t_renovate_bootstrap_assert_pristine "${repo}"

t_case "a real apply initializes the pinned hub and forwards arguments"
repo="$(make_fixture apply)" || exit 1
t_assert_rc 0 run_wrapper "${repo}" --apply --managers git-submodules
t_assert_eq pinned "$(sed -n '1p' "${WORK}/apply/driver.args")"
t_assert_contains "$(sed -n '2p' "${WORK}/apply/driver.args")" "--apply --managers git-submodules"
t_assert_eq "$(git -C "${repo}" rev-parse HEAD:third_party/ANTfrastructure)" \
  "$(git -C "${repo}/third_party/ANTfrastructure" rev-parse HEAD)"

t_case "a fatal driver status undoes bootstrap and restores the parent config"
repo="$(make_fixture fatal)" || exit 1
DRIVER_EXIT=7 t_assert_rc 7 run_wrapper "${repo}" --apply
t_assert_fails test -e "${repo}/third_party"
t_assert_ok cmp -s "${WORK}/fatal/config.before" "${repo}/.git/config"

t_case "an invalid explicit hub never falls through to bootstrap"
repo="$(make_fixture explicit)" || exit 1
explicit_rc=0
explicit_output="$(run_wrapper "${repo}" --hub "${WORK}/missing" --apply 2>&1)" || explicit_rc=$?
t_assert_eq 1 "${explicit_rc}"
t_assert_contains "${explicit_output}" "does not hold"
t_assert_fails test -e "${repo}/third_party"
t_assert_ok cmp -s "${WORK}/explicit/config.before" "${repo}/.git/config"

t_case "an existing candidate wins before bootstrap, and explicit --hub wins first"
repo="$(make_fixture candidates)" || exit 1
mkdir -p "${repo}/antfrastructure-tools/linux/scripts" "${WORK}/explicit-hub/linux/scripts"
cat > "${repo}/antfrastructure-tools/linux/scripts/renovate-local.sh" <<'SH'
#!/usr/bin/env bash
printf 'tools\n' > "${DRIVER_ARGS:?}"
SH
cat > "${WORK}/explicit-hub/linux/scripts/renovate-local.sh" <<'SH'
#!/usr/bin/env bash
printf 'explicit\n' > "${DRIVER_ARGS:?}"
SH
t_assert_rc 0 run_wrapper "${repo}" --apply
t_assert_eq tools "$(cat "${WORK}/candidates/driver.args")"
t_assert_fails test -e "${repo}/third_party"
t_assert_rc 0 run_wrapper "${repo}" --hub "${WORK}/explicit-hub" --apply
t_assert_eq explicit "$(cat "${WORK}/candidates/driver.args")"
t_assert_fails test -e "${repo}/third_party"

t_case "removing the bootstrap dispatch makes a proven first apply fail"
repo="$(make_fixture mutation_control)" || exit 1
t_assert_rc 0 run_wrapper "${repo}" --apply
repo="$(make_fixture mutation)" || exit 1
python3 - "${repo}/scripts/linux/renovate-local.sh" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
source = path.read_text(encoding="utf-8")
needle = '  if [ "${_HUB_FOUND}" -eq 0 ] && ('
if source.count(needle) != 1:
    raise SystemExit("bootstrap mutation target is missing or ambiguous")
path.write_text(source.replace(needle, "  if false && ("), encoding="utf-8")
PY
mutation_rc=0
mutation_output="$(run_wrapper "${repo}" --apply 2>&1)" || mutation_rc=$?
t_assert_eq 1 "${mutation_rc}"
t_assert_contains "${mutation_output}" "no ANTfrastructure checkout holding"
t_assert_fails test -e "${repo}/third_party"

t_summary
