#!/usr/bin/env bash
# A local Git fixture proves the custom hub lookup and first apply without running Renovate.
set -u
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
# shellcheck source=third_party/ANTfrastructure/linux/scripts/tests/test-harness.sh
source "${REPO_ROOT}/third_party/ANTfrastructure/linux/scripts/tests/test-harness.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

make_fixture() {
  local base="${WORK}/$1" seed="${WORK}/$1/seed" remote="${WORK}/$1/hub.git"
  local repo="${WORK}/$1/consumer" sha
  mkdir -p "${seed}/linux/scripts" "${repo}/scripts/linux" "${repo}/scripts/lib"
  git -C "${seed}" init -q -b develop
  git -C "${seed}" config user.name Fixture
  git -C "${seed}" config user.email fixture@example.invalid
  cat > "${seed}/linux/scripts/renovate-local.sh" <<'SH'
#!/usr/bin/env bash
printf 'pinned\n%s\n' "$*" > "${DRIVER_ARGS:?}"
exit "${DRIVER_EXIT:-0}"
SH
  git -C "${seed}" add linux/scripts/renovate-local.sh
  git -C "${seed}" commit -qm seed
  sha="$(git -C "${seed}" rev-parse HEAD)"
  git clone --quiet --bare "${seed}" "${remote}"
  git -C "${remote}" symbolic-ref HEAD refs/heads/develop

  git -C "${repo}" init -q -b develop
  git -C "${repo}" config user.name Fixture
  git -C "${repo}" config user.email fixture@example.invalid
  cp "${REPO_ROOT}/scripts/linux/renovate-local.sh" "${repo}/scripts/linux/"
  cp "${REPO_ROOT}/scripts/lib/find-hub.sh" "${REPO_ROOT}/scripts/lib/antfrastructure.sh" "${repo}/scripts/lib/"
  printf '[submodule "third_party/ANTfrastructure"]\n\tpath = third_party/ANTfrastructure\n\turl = %s\n' "${remote}" > "${repo}/.gitmodules"
  git -C "${repo}" add .gitmodules scripts
  git -C "${repo}" update-index --add --cacheinfo "160000,${sha},third_party/ANTfrastructure"
  git -C "${repo}" commit -qm consumer
  printf '\n# keep this config comment\n' >> "${repo}/.git/config"
  cp -p "${repo}/.git/config" "${base}/config.before"
  printf '%s' "${repo}"
}

run_wrapper() {
  local repo="$1"; shift
  env -u ANTFRASTRUCTURE_DIR -u KATAGLYPHIS_REPO_ROOT \
    DRIVER_ARGS="${repo%/consumer}/driver.args" GIT_ALLOW_PROTOCOL=file TMPDIR="${WORK}" \
    bash "${repo}/scripts/linux/renovate-local.sh" "$@"
}

t_case "report, dry-run and help do not initialize a missing pinned hub"
repo="$(make_fixture preview)"
t_assert_rc 0 run_wrapper "${repo}" --help
t_assert_fails run_wrapper "${repo}"
t_assert_fails run_wrapper "${repo}" --apply --dry-run
t_assert_fails test -e "${repo}/third_party"
t_assert_ok cmp -s "${WORK}/preview/config.before" "${repo}/.git/config"
t_assert_fails test -e "${WORK}/preview/driver.args"

t_case "a real apply initializes the pinned hub and forwards arguments"
repo="$(make_fixture apply)"
t_assert_rc 0 run_wrapper "${repo}" --apply --managers git-submodules
t_assert_eq pinned "$(sed -n '1p' "${WORK}/apply/driver.args")"
t_assert_contains "$(sed -n '2p' "${WORK}/apply/driver.args")" "--apply --managers git-submodules"
t_assert_eq "$(git -C "${repo}" rev-parse HEAD:third_party/ANTfrastructure)" \
  "$(git -C "${repo}/third_party/ANTfrastructure" rev-parse HEAD)"

t_case "a fatal driver status undoes bootstrap and restores the parent config"
repo="$(make_fixture fatal)"
DRIVER_EXIT=7 t_assert_rc 7 run_wrapper "${repo}" --apply
t_assert_fails test -e "${repo}/third_party"
t_assert_ok cmp -s "${WORK}/fatal/config.before" "${repo}/.git/config"

t_case "an invalid explicit hub never falls through to bootstrap"
repo="$(make_fixture explicit)"
explicit_rc=0
explicit_output="$(run_wrapper "${repo}" --hub "${WORK}/missing" --apply 2>&1)" || explicit_rc=$?
t_assert_eq 1 "${explicit_rc}"
t_assert_contains "${explicit_output}" "does not hold"
t_assert_fails test -e "${repo}/third_party"
t_assert_ok cmp -s "${WORK}/explicit/config.before" "${repo}/.git/config"

t_case "an existing candidate wins before bootstrap, and explicit --hub wins first"
repo="$(make_fixture candidates)"
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
repo="$(make_fixture mutation_control)"
t_assert_rc 0 run_wrapper "${repo}" --apply
repo="$(make_fixture mutation)"
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
