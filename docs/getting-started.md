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

## Dependency upgrades

No workflow runs Renovate here, so it blocks nothing and nobody runs it for you; dependabot
watches only pub (`.github/dependabot.yml`). How the local CLI works, `--apply`, the token and WSL:
[ANTfrastructure's `dependency-updates.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/dependency-updates.md).

```sh
bash scripts/linux/renovate-local.sh                          # report (managers detected from the tree)
bash scripts/linux/renovate-local.sh --hub ../ANTfrastructure # if it cannot find the hub
bash scripts/linux/renovate-local.sh --managers pub           # narrow it
```

With no gitlinks here, every `--apply` update is a manifest edit, `pubspec.yaml` among them
(go_router to `^18.0.0`, bb492b9).
