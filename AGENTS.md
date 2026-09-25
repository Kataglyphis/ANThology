# AGENTS.md

Guidance for coding agents (and new contributors) working in ANThology.

## 1. What this project is

ANThology is the shared Flutter/Dart UI package (`anthology` in `pubspec.yaml`)
that OmniAccelerANT and jotrockenmitlocken consume as the path dependency
`third_party/ANThology`. It carries the half those two apps genuinely share:
the page shells, routing, decoration and media widgets, the l10n catalogue and
the asset corpus (fonts, images, legal texts) they both load.

| Path | What lives there |
| --- | --- |
| `lib/app_shell.dart`, `lib/app_settings.dart`, `lib/app_attributes.dart`, `lib/blog_page_config.dart` | The top-level entry points an app wires its settings, attributes and blog config into |
| `lib/Decoration/` (incl. `Charts/`) | Box/component decoration, dividers, the fl_chart pie chart |
| `lib/Layout/` | Adaptive grid and the responsive-design helpers |
| `lib/Media/` | Markdown, image, data table, file table, download/open/copy/email widgets |
| `lib/Pages/` | The `Home` navigation scaffold and the consolidated pages (landing, about, data, error, footer, sqlite, markdown content), with their configs |
| `lib/Routing/` | go_router creation, navigation bars, screen configurations |
| `lib/SocialMedia/` | Social media icons and their settings |
| `lib/Sqlite/` | The sqlite3 self-test with io/web/stub implementations |
| `lib/Url/` | Browser helper and external link config |
| `lib/Widgets/` | Small shared widgets (skill table) |
| `lib/l10n/` | The en/de/fr `.arb` catalogues and the committed generated Dart |
| `assets/` | The shared corpus both apps reference as `packages/anthology/assets/...` |
| `scripts/lib/find-hub.sh` | The hub lookup ladder both wrappers below share |
| `scripts/run-dart-checks.sh` | The Dart gate as one command; what `docs.yml` runs |
| `scripts/linux/renovate-local.sh` | Execs the hub's Renovate driver; no lane runs it |
| `test/` | Widget and localisation tests, run by the Dart gate |

There is **no `third_party/`** and no `.gitmodules`: this repo has no
ANTfrastructure submodule (section 4).

## 2. What ANTfrastructure owns — links only

**Do not restate procedures in this section.** One line of orientation, then the
link. If you catch yourself typing a command that would work in another repo,
it belongs upstream.

Start at
[ANTfrastructure `docs/INDEX.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/INDEX.md)
— topic → owning document, so these links stay valid when upstream reorganises.

| Topic | Where |
| --- | --- |
| The Dart gate: which files it formats, analyzes and tests | [`docs/code-quality-tooling.md#dart-file-enumeration`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/code-quality-tooling.md#dart-file-enumeration) |
| The shared shell libraries the hub scripts are built on | [`docs/shared-script-libraries.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/shared-script-libraries.md) |
| Renovate as a local CLI: managers, tokens, why the App is not installed | [`docs/dependency-updates.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/dependency-updates.md) |
| The one FTP publish policy `docs.yml` deploys through | [`docs/ftp-deploys.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/ftp-deploys.md) |
| What the CI image ships (uid, Flutter on PATH) and promises | [`docs/consumer-image-contract.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/consumer-image-contract.md) |

The three upstream scripts this repo actually executes. None of them is copied
here; a local file that looks like one of them is a wrapper that finds it and
execs it (section 1), so fix behaviour upstream, never in the wrapper.

| Hub script | What it is to this repo |
| --- | --- |
| [`linux/scripts/05-frameworks/flutter/flutter_checks.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/05-frameworks/flutter/flutter_checks.sh) | The Dart gate itself: pub get, pubspec structure, format, analyze, test. `scripts/run-dart-checks.sh` runs it at `--strict true` |
| [`linux/scripts/run-lint-gates.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/run-lint-gates.sh) | The six lint gates plus the `--ratchets` measurement gates. `docs.yml`'s `lint` job calls it directly — there is no wrapper (section 4) |
| [`linux/scripts/renovate-local.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/renovate-local.sh) | The Renovate driver. `scripts/linux/renovate-local.sh` finds a hub and execs it; no lane does |

## 3. Critical invariant: the hub is checked out at `develop`

`docs.yml` checks the hub out at `ref: develop` and calls its composite actions at
`@develop`, so a hub change a lane depends on must be pushed **first**; no
Submodule.Pins suite applies, because there is no gitlink to guard. Both moved
off `main` by owner directive on 2026-09-25: hub `main` is a release branch that
lags `develop`. The hub links in this file and README.md point at `develop` for
the same reason.

## 4. Pitfalls specific to this project

- **No ANTfrastructure submodule, by decision.** The reasoning is written down
  by its owners and is not repeated here: the
  [`docs.yml` `lint` job header](.github/workflows/docs.yml) (why there is no
  local lint wrapper, and why the image ref is not repeated either) and the
  [`renovate-local.sh` header](scripts/linux/renovate-local.sh) (why Renovate
  still gets one). The README's
  [Renovate section](README.md#what-is-behind-renovate-as-a-local-cli) covers
  the user-facing side. `.antfrastructure-shared.manifest` is empty for the
  same reason.
- **Both wrappers FIND the hub; neither assumes one.**
  [`scripts/lib/find-hub.sh`](scripts/lib/find-hub.sh) owns the one ladder:
  `--hub`, then `$ANTFRASTRUCTURE_DIR`, then `./antfrastructure-tools` (what
  `docs.yml` creates in CI), then `./third_party/ANTfrastructure` (if this repo
  ever grows the submodule), then `../ANTfrastructure` and
  `../../ANTfrastructure` (a sibling clone on a dev box). A rung counts only if
  the file the caller named is really inside it, an explicitly wrong `--hub` is
  an error rather than something to probe past, and a miss prints every path it
  tried. Do not retype the ladder into a new script — source that file.
- **The Dart gate formats TRACKED files, never `dart format .`.** The hub
  enumerates `git ls-files` instead of walking the tree: a recursive walk once
  reformatted a Flutter SDK unpacked inside a consumer's workspace
  (OmniAccelerANT, measured 2026-09-03). This lane takes Flutter from the image
  (`/opt/flutter`, since 2026-09-07), but the enumeration stays, so a new
  `.dart` file escapes the format check — not `dart analyze` or `flutter test`
  — until it is `git add`ed. `scripts/run-dart-checks.sh` takes no arguments:
  `--strict false` would turn the blocking gate into a warning.
- The generated Dart under `lib/l10n/` is committed: a consumer's
  `flutter pub get` never runs gen-l10n for a dependency (`pubspec.yaml`).
- Package fonts register as `packages/anthology/<family>`; a bare family name
  silently falls back to the platform default (`pubspec.yaml`, `fonts:`).
- An asset is only in a bundle if `pubspec.yaml` declares it, and only worth
  tracking if one of the two apps names it. Grep both consumers for a basename
  before adding or deleting one. The Dart gate fails a declared path that
  bundles nothing (a missing file, or a directory with no file directly in it).

## 5. Build, run, test

`<hub>` is `./antfrastructure-tools` in CI (what the checkout step in `docs.yml`
creates) and a sibling ANTfrastructure clone locally. The two wrappers find it
on their own; the direct calls below are for when you want a different one.

```bash
# The Dart gate CI runs: pub get, pubspec structure, format on tracked files,
# analyze, test
bash scripts/run-dart-checks.sh
bash <hub>/linux/scripts/05-frameworks/flutter/flutter_checks.sh --strict true
# The lint gates CI runs (shellcheck, actionlint, gitleaks, ... + the ratchets)
bash <hub>/linux/scripts/run-lint-gates.sh "$(pwd)" --ratchets
# doc/api, which docs.yml deploys
dart doc
# after editing any lib/l10n/*.arb; commit the generated Dart
flutter gen-l10n
# what is behind (report only; no lane runs it)
GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/linux/renovate-local.sh
```

## 6. Docs owned by this repo

- `README.md` — what the package is, the Renovate wrapper, getting started.
- `CHANGELOG.md` — one entry per released `pubspec.yaml` version.
- The `dart doc` output in `doc/api` (not tracked), generated by `docs.yml` and
  published to **omnifronteer.jonasheinle.de** — the package's official docs
  site, which README.md links under its title. It goes out through the
  family's one FTP publish policy, not a per-repo action:
  [`docs/ftp-deploys.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/ftp-deploys.md).

A change to user-facing behaviour updates its doc in the same commit.
