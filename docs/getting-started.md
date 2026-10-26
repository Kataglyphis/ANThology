# Getting started

What ANThology needs, the Dart gate CI runs, what to try when things go wrong, and how its
dependencies move. The rules behind each command: [AGENTS.md](../AGENTS.md).

## Prerequisites

[Install Flutter/Dart](https://docs.flutter.dev/get-started/install). CI takes Flutter from the
family image instead, and its version must satisfy the `flutter:` floor in `pubspec.yaml`.

The scripts under `scripts/` need an ANTfrastructure checkout, and this repository has none of
its own; a sibling clone is enough:

```sh
git clone --branch develop https://github.com/Kataglyphis/ANThology.git
git clone --depth 1 --branch develop https://github.com/Kataglyphis/ANTfrastructure.git
cd ANThology
bash scripts/run-dart-checks.sh   # the Dart gate CI runs: pub get, format, analyze, test
bash scripts/run-dart-checks.sh --test-platform chrome   # the same, the tests in Chrome
```

How the scripts find that checkout: [AGENTS.md § 4](../AGENTS.md#4-pitfalls-specific-to-this-project).
When none of the paths they probe holds the tool, they print every path they tried and the
`git clone` that fixes it, never a bare "command not found". Every other command, the lint gates
and `flutter gen-l10n` among them: [AGENTS.md § 5](../AGENTS.md#5-build-run-test).

## Tips

When things go wrong:

```sh
flutter clean
flutter pub get
flutter test
```

A package has no platform runner, so there is nothing to `flutter build` here; build one of the
apps that consume it.

## Application state and files

`KataglyphisAppShell` keeps its router and routed page states when the user changes language,
theme or window size. `AppAttributesScope` supplies the current settings to page builders.
Stateful widgets which cache asset content refresh it when their input path or locale changes.

`OpenButton` and `DownloadButton` share `FileActions`: browsers open or download the asset URL;
native apps extract bundle bytes and use the system application or save dialog. A failed action
shows a localized message. Tests can inject `FileActions` without opening another application.

The dev-only package under `packages/anthology_test_support` registers layout checks and taps the
real bottom navigation, brightness and language buttons. Consumers provide their app factory,
route list and navigation target; see its
[README](https://github.com/Kataglyphis/ANThology/blob/develop/packages/anthology_test_support/README.md).

## Dependency upgrades

No workflow runs Renovate here, so it blocks nothing and nobody runs it for you; it is the only
dependency watch, since Dependabot is off (owner, 2026-10-20). How the local CLI works, `--apply`,
the token and WSL:
[ANTfrastructure's `dependency-updates.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/dependency-updates.md).

```sh
bash scripts/linux/renovate-local.sh                          # report (managers detected from the tree)
bash scripts/linux/renovate-local.sh --hub ../ANTfrastructure # if it cannot find the hub
bash scripts/linux/renovate-local.sh --managers pub           # narrow it
```

With `--apply`, Renovate can update `pubspec.yaml` and the recorded
`third_party/ANTfrastructure` gitlink to its remote default tip. A real apply initializes a
missing pinned hub through the copied shared bootstrap. To review the plan first with
`--apply --dry-run`, initialize that checkout or provide an existing hub with `--hub`; a
preview never clones it. The copied Git mode helper selects Windows Git when WSL opens a
Windows-authored checkout. An explicit invalid `--hub` still fails rather than falling back.
