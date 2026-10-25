# AGENTS.md

Guidance for coding agents (and new contributors) working in ANThology.

## 1. What this project is

The shared Flutter/Dart UI package (`anthology` in `pubspec.yaml`) that OmniAccelerANT and
jotrockenmitlocken consume as the path dependency `third_party/ANThology`. It carries what the two
apps share: the page shells, routing, decoration and media widgets, the l10n catalogue and the
asset corpus (fonts, images, legal texts) they both load.

| Path | What lives there |
| --- | --- |
| `lib/app_shell.dart`, `lib/app_settings.dart`, `lib/app_attributes.dart`, `lib/blog_page_config.dart` | The top-level entry points an app wires its settings, attributes and blog config into |
| `lib/settings_loader.dart` | `SettingsLoader`: the three settings files both apps boot from, read in parallel, logged and rethrown on failure |
| `lib/Boot/` | `dismissBootOverlay()`: removes the loading overlay of the hub's shared web shell (`shared/web/` in ANTfrastructure); a no-op off the web |
| `lib/locale_helpers.dart` | `isGermanLocale`, `localizedValue`: by language code, so `de_AT` is German |
| `lib/Decoration/` (incl. `Charts/`) | Box/component decoration, dividers, the fl_chart pie chart |
| `lib/Layout/` | Adaptive grid and the responsive-design helpers |
| `lib/Media/` | Markdown, image, data table, file table, download/open/copy/email widgets |
| `lib/Pages/` | The `Home` navigation scaffold and the consolidated pages (landing, about, data, error, footer, sqlite, markdown content), with their configs |
| `lib/Routing/` | go_router creation, navigation bars, screen configurations |
| `lib/SocialMedia/` | Social media icons and their settings |
| `lib/Sqlite/` | `loadSqlite3`: FFI natively, `sqlite3.wasm` on the web over IndexedDB or in memory; the self-test, the healthcheck and its widget |
| `lib/Testing/` | `loadAnthologyFonts()` for widget tests that measure real text; no `flutter_test` dependency |
| `packages/anthology_test_support/` | Dev-only layout and navigation contracts both apps run; owns the `flutter_test` dependency |
| `lib/Url/` | Browser helper and external link config |
| `lib/Widgets/` | Small shared widgets (skill table) |
| `lib/l10n/` | The en/de/fr `.arb` catalogues and the committed generated Dart |
| `assets/` | The shared corpus both apps reference as `packages/anthology/assets/...` |
| `scripts/lib/find-hub.sh` | The hub lookup ladder the three wrappers below share |
| `scripts/lib/antfrastructure.sh` | Copied shared bootstrap for Renovate's first real apply when the pinned hub is absent |
| `scripts/run-dart-checks.sh` | The Dart gate as one command; what `docs.yml`'s `checks` job runs, on the VM and again in Chrome |
| `scripts/build-docs.sh` | The docs site into `doc/api`: `dart doc`, the family theme, the `docs/` guides; what `docs.yml`'s `docs` job runs |
| `scripts/linux/renovate-local.sh` | Resolves a hub or bootstraps its pinned gitlink, then runs the driver (section 4) |
| `scripts/tests/test-renovate-wrapper.sh` | Offline Git fixture for the custom hub lookup and first real apply, run by `renovate-entrypoint.yml` |
| `test/` | Widget and localisation tests, run by the Dart gate |

`third_party/ANTfrastructure` pins the reusable quality and build tooling; its
`.gitmodules` branch is `develop` (section 3).

## 2. What ANTfrastructure owns — links only

**Do not restate procedures here**: one line of orientation, then the link. A command that would
work in another repo belongs upstream.

Start at
[ANTfrastructure `docs/INDEX.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/INDEX.md):
topic → owning document, so these links stay valid when upstream reorganises.

| Topic | Where |
| --- | --- |
| The Dart gate: which files it formats, analyzes and tests | [`docs/code-quality-tooling.md#dart-file-enumeration`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/code-quality-tooling.md#dart-file-enumeration) |
| The shared shell libraries the hub scripts are built on | [`docs/shared-script-libraries.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/shared-script-libraries.md) |
| Renovate as a local CLI: managers, tokens, why the App is not installed | [`docs/dependency-updates.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/dependency-updates.md) |
| How the docs site is built, link-checked and published (`build-docs.yml`, which `docs.yml`'s `docs` job calls) | [`docs/docs-sites.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/docs-sites.md) |
| What the CI image ships (uid, Flutter on PATH) and promises | [`docs/consumer-image-contract.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/consumer-image-contract.md) |
| Code comments: one line, only the why; API docs short; gated | [the hub rule, Comments](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/AGENTS.md#comments-one-line-only-the-why) |
| Searching the tree: `rg`, not `grep -r` | [the hub rule, Searching](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/AGENTS.md#searching-the-tree-ripgrep-rg) |

The four hub scripts this repo executes. None is copied here; a local file that looks like one is
a wrapper that finds and runs it (section 1), so fix behaviour upstream, never in the wrapper.

| Hub script | What it is to this repo |
| --- | --- |
| [`linux/scripts/05-frameworks/flutter/flutter_checks.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/05-frameworks/flutter/flutter_checks.sh) | The Dart gate itself: pub get, pubspec structure, format, analyze, test. `scripts/run-dart-checks.sh` runs it at `--strict true` |
| [`linux/scripts/run-lint-gates.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/run-lint-gates.sh) | The lint gates plus the `--ratchets` measurement gates; `docs.yml` calls the reusable lint workflow |
| [`linux/scripts/renovate-local.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/renovate-local.sh) | The Renovate driver. `scripts/linux/renovate-local.sh` resolves a hub or initializes its pinned gitlink for a real apply; CI checks the entrypoint with an offline fixture instead of applying live upgrades |
| [`linux/scripts/lib/dartdoc-build.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/lib/dartdoc-build.sh) | The docs build. `scripts/build-docs.sh` sources it with the theme and the guide list, which `build-docs.yml`'s `builder: dartdoc` cannot take |

## 3. Critical invariant: the hub is pinned from `develop`

`third_party/ANTfrastructure` is a recorded gitlink taken from hub `develop`.
`docs.yml` calls the reusable workflows and actions at `@develop`, so a hub change a
lane depends on must be pushed first, then the gitlink advanced and checked by
`submodule-pins.yml`. The hub's `main` is a release branch that lags `develop`.

## 4. Pitfalls specific to this project

- **The shell owns one router for its lifetime.** `AppAttributesScope` updates the routed
  widgets when language, theme or breakpoints change. Replacing the router discards drafts and
  stops OmniAccelerANT's webcam and ESP32 sessions. A stateful asset widget reloads its future
  in `didUpdateWidget` when its path, locale or bundle changes, never just on a theme change.
- **File buttons use `Media/Files/file_actions.dart`.** Native actions extract bundled bytes
  before opening a system application or save dialog; the web uses the bundle's asset URL.
  Inject `FileActions` for button tests and handle a failed action through the shared feedback.
- **Consumer widget contracts are dev dependencies.** Point `anthology_test_support` at
  `third_party/ANThology/packages/anthology_test_support`; keep `flutter_test` out of this
  package's production dependencies. Each consumer supplies its app factory and route list.
- **The hub submodule is the local tooling source.** `.antfrastructure-shared.manifest`
  declares only the copied shell bootstrap needed before that submodule exists. `docs.yml` calls the
  reusable lint workflow and builds docs from the pinned submodule. The Renovate
  wrapper remains the dependency updater; Dependabot is off. User-facing side:
  [docs/getting-started.md § Dependency upgrades](docs/getting-started.md#dependency-upgrades).
- **The wrappers FIND the hub; none assumes one.**
  [`scripts/lib/find-hub.sh`](scripts/lib/find-hub.sh) owns the one ladder, in order:
  1. `--hub`
  2. `$ANTFRASTRUCTURE_DIR`
  3. `./third_party/ANTfrastructure` (the pinned submodule)
  4. `./antfrastructure-tools` (an optional separate checkout)
  5. `../ANTfrastructure` and `../../ANTfrastructure` (a sibling clone on a dev box)

  A rung counts only if the file the caller named is really inside it; an explicitly wrong
  `--hub` is an error, not something to probe past; a miss prints every path it tried. Never
  retype the ladder into a new script: source that file.
  Renovate initializes the pinned hub only for a real `--apply` when none of those candidates
  provides its driver. Report and dry-run leave it absent; explicit `--hub` errors remain fatal.
- **The Dart gate formats TRACKED files, never `dart format .`**
  ([hub § *`dart format`: the tracked files*](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/code-quality-tooling.md#dart-format-the-tracked-files-in-the-floors-style)),
  so a new `.dart` file escapes the format check (not `dart analyze` or `flutter test`) until it
  is `git add`ed. `scripts/run-dart-checks.sh` takes only `--test-platform <vm|chrome>`:
  `--strict false` would turn the blocking gate into a warning.
- **The suite runs twice, on the VM and in Chrome** (2026-10-21): the web halves of `lib/Boot/`
  and `lib/Sqlite/` load only in a browser. A test that reads the checkout or loads an asset
  through `rootBundle` (a browser test serves none) is `@TestOn('vm')`; a browser-only one is
  `@TestOn('browser')`.
- **`loadSqlite3(indexedDbName:)` names a database in the visitor's browser.** OmniAccelerANT
  passes `kataglyphis_inference_engine` and jotrockenmitlocken passes none (in memory). A new name
  opens a new, empty database and orphans the old one, so an app never renames its own.
- The generated Dart under `lib/l10n/` is committed: a consumer's `flutter pub get` never runs
  gen-l10n for a dependency (`pubspec.yaml`).
- Package fonts register as `packages/anthology/<family>`; a bare family name silently falls back
  to the platform default (`pubspec.yaml`, `fonts:`).
- An asset is in a bundle only if `pubspec.yaml` declares it, and worth tracking only if one of
  the two apps names it. Grep both consumers for a basename before adding or deleting one. The
  Dart gate fails a declared path that bundles nothing (a missing file, or a directory with no
  file directly in it).

## 5. Build, run, test

`<hub>` is `./third_party/ANTfrastructure` in CI and after
`git submodule update --init -- third_party/ANTfrastructure` locally. The wrappers
find it; the direct calls below name it explicitly.

```bash
# The Dart gate CI runs: pub get, pubspec structure, format on tracked files,
# analyze, test; then again with the tests in the image's Chrome
bash scripts/run-dart-checks.sh
bash scripts/run-dart-checks.sh --test-platform chrome
bash <hub>/linux/scripts/05-frameworks/flutter/flutter_checks.sh --strict true
# The lint gates CI runs (shellcheck, actionlint, gitleaks, ... + the ratchets)
bash <hub>/linux/scripts/run-lint-gates.sh "$(pwd)" --ratchets
# doc/api as the docs job builds it, then its .htaccess, 404 page and link gate
bash scripts/build-docs.sh
bash <hub>/linux/scripts/docs-site.sh stage doc/api
# after editing any lib/l10n/*.arb; commit the generated Dart
flutter gen-l10n
# what is behind (report only; no lane runs it)
GITHUB_COM_TOKEN="$(gh auth token)" bash scripts/linux/renovate-local.sh
```

## 6. Docs owned by this repo

**Write docs like a developer: short and precise** (owner, 2026-10-19). Say what a thing does,
how to run it and what breaks; no filler, no marketing, no repetition.

| Doc | Holds |
| --- | --- |
| `README.md` | The overview, in the family's [README shape](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/repository-family.md#the-readme-rule). `dart doc` renders it as the docs site's front page, so its links into this repo are absolute GitHub URLs |
| `docs/getting-started.md` | Prerequisites, the Dart gate, tips, and the Renovate wrapper's commands. Also on the docs site as `guide-getting-started.html`; a new page in `docs/` goes into `DARTDOC_BUILD_GUIDES` in `scripts/build-docs.sh` |
| `CHANGELOG.md` | One entry per released `pubspec.yaml` version |
| `doc/api` (not tracked) | The site `scripts/build-docs.sh` builds, published to **omnifronteer.jonasheinle.de**, the package's official docs site, which README.md links under its title. `docs.yml`'s `docs` job calls the hub's [`build-docs.yml`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/docs-sites.md): a pull request builds and link-checks it, only a push to `develop` or `main` publishes it, with the `SERVER`, `USERNAME` and `PW` secrets |

A change to user-facing behaviour updates its doc in the same commit. A page that restates a hub
page fails the lint gates (`doc-dupes --against-hub`): link to the hub instead. A passage that must
stay is budgeted in `doc-dupes-hub.allow`, with its reason.
