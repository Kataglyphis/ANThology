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
| `lib/Media/` | Markdown, image, data table, download/open/copy/email widgets |
| `lib/Pages/` | The consolidated pages (landing, about, data, error, footer, sqlite, markdown content) and their configs |
| `lib/Routing/` | go_router creation, navigation bars, screen configurations |
| `lib/SocialMedia/` | Social media icons and their settings |
| `lib/Sqlite/` | The sqlite3 self-test with io/web/stub implementations |
| `lib/Url/` | Browser helper and external link config |
| `lib/Widgets/` | Small shared widgets (skill table) |
| `lib/l10n/` | The en/de/fr `.arb` catalogues and the committed generated Dart |
| `assets/` | The shared corpus both apps reference as `packages/anthology/assets/...` |
| `scripts/renovate-local.sh` | The one wrapper this repo has: finds an ANTfrastructure checkout, execs the hub's Renovate driver |
| `test/` | Widget and localisation tests, run by the Dart gate |

There is **no `third_party/`** and no `.gitmodules`: this repo has no
ANTfrastructure submodule (section 4).

## 2. What ANTfrastructure owns — links only

**Do not restate procedures in this section.** One line of orientation, then the
link. If you catch yourself typing a command that would work in another repo,
it belongs upstream.

Start at
[ANTfrastructure `docs/INDEX.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/INDEX.md)
— topic → owning document, so these links stay valid when upstream reorganises.

| Topic | Where |
| --- | --- |
| The Dart gate: which files it formats, analyzes and tests | [`docs/code-quality-tooling.md#dart-file-enumeration`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/code-quality-tooling.md#dart-file-enumeration) |
| The shared shell libraries the hub scripts are built on | [`docs/shared-script-libraries.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/shared-script-libraries.md) |
| Renovate as a local CLI: managers, tokens, why the App is not installed | [`docs/dependency-updates.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/dependency-updates.md) |
| The one FTP publish policy `dart.yml` deploys through | [`docs/ftp-deploys.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/ftp-deploys.md) |
| What the CI image ships (uid, Flutter on PATH) and promises | [`docs/consumer-image-contract.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/consumer-image-contract.md) |

## 3. Critical invariant: the hub is checked out at `main`

`dart.yml` and `lint-gates.yml` check the hub out at `ref: main` and call its
composite actions at `@main`, so a hub change a lane depends on must be pushed
**first**; no Submodule.Pins suite applies, because there is no gitlink to
guard.

## 4. Pitfalls specific to this project

- **No ANTfrastructure submodule, by decision.** The reasoning is written down
  by its three owners and is not repeated here: the
  [`lint-gates.yml` header](.github/workflows/lint-gates.yml) (why no local
  lint wrapper), the [`renovate-local.sh` header](scripts/renovate-local.sh)
  (why Renovate still gets one, and how it finds the hub) and the
  [`dart.yml` header](.github/workflows/dart.yml) (why the image ref is not
  repeated either). The README's
  [Renovate section](README.md#what-is-behind-renovate-as-a-local-cli) covers
  the user-facing side. `.antfrastructure-shared.manifest` is empty for the
  same reason.
- The generated Dart under `lib/l10n/` is committed: a consumer's
  `flutter pub get` never runs gen-l10n for a dependency (`pubspec.yaml`).
- Package fonts register as `packages/anthology/<family>`; a bare family name
  silently falls back to the platform default (`pubspec.yaml`, `fonts:`).

## 5. Build, run, test

`<hub>` is `./antfrastructure-tools` in CI (what the checkout step in both
workflows creates) and a sibling ANTfrastructure clone locally.

```bash
# The Dart gate CI runs: pub get, format on tracked files, analyze, test
bash <hub>/linux/scripts/05-frameworks/flutter/flutter_checks.sh --strict true
# The lint gates CI runs (shellcheck, actionlint, gitleaks, ...)
bash <hub>/linux/scripts/run-lint-gates.sh "$(pwd)"
# doc/api, which dart.yml deploys
dart doc
# after editing any lib/l10n/*.arb; commit the generated Dart
flutter gen-l10n
# what is behind (report only; no lane runs it)
GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/renovate-local.sh
```

## 6. Docs owned by this repo

- `README.md` — what the package is, the Renovate wrapper, getting started.
- `CHANGELOG.md` — one entry per released `pubspec.yaml` version.
- The `dart doc` output in `doc/api`, generated and deployed by `dart.yml`
  (not tracked).

A change to user-facing behaviour updates its doc in the same commit.
