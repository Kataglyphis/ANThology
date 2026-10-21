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
| `lib/Url/` | Browser helper and external link config |
| `lib/Widgets/` | Small shared widgets (skill table) |
| `lib/l10n/` | The en/de/fr `.arb` catalogues and the committed generated Dart |
| `assets/` | The shared corpus both apps reference as `packages/anthology/assets/...` |
| `scripts/lib/find-hub.sh` | The hub lookup ladder the three wrappers below share |
| `scripts/run-dart-checks.sh` | The Dart gate as one command; what `docs.yml`'s `checks` job runs |
| `scripts/build-docs.sh` | The docs site into `doc/api`: `dart doc`, the family theme, the `docs/` guides; what `docs.yml`'s `docs` job runs |
| `scripts/linux/renovate-local.sh` | Execs the hub's Renovate driver (section 4) |
| `test/` | Widget and localisation tests, run by the Dart gate |

There is **no `third_party/`** and no `.gitmodules`: this repo has no ANTfrastructure submodule
(section 4).

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
| [`linux/scripts/run-lint-gates.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/run-lint-gates.sh) | The lint gates plus the `--ratchets` measurement gates, listed in its header. `docs.yml`'s `lint` job calls it directly — there is no wrapper (section 4) |
| [`linux/scripts/renovate-local.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/renovate-local.sh) | The Renovate driver. `scripts/linux/renovate-local.sh` finds a hub and execs it; no lane does |
| [`linux/scripts/lib/dartdoc-build.sh`](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/linux/scripts/lib/dartdoc-build.sh) | The docs build. `scripts/build-docs.sh` sources it with the theme and the guide list, which `build-docs.yml`'s `builder: dartdoc` cannot take |

## 3. Critical invariant: the hub is checked out at `develop`

`docs.yml` checks the hub out at `ref: develop` and calls its composite actions and
`build-docs.yml` at `@develop`, so a hub change a lane depends on must be pushed **first**. No
Submodule.Pins suite applies: there is no gitlink to guard. Both moved off `main` by owner
directive on 2026-09-25, because hub `main` is a release branch that lags `develop`; the hub links
in this file and README.md point at `develop` for the same reason.

## 4. Pitfalls specific to this project

- **No ANTfrastructure submodule, by decision.** A submodule would pin what `docs.yml` and
  `renovate.json` deliberately keep floating at `develop`. `.antfrastructure-shared.manifest` is
  empty for the same reason.
  - **No local lint wrapper.** The canonical bootstrap's not-found hint
    (`git submodule update ... third_party/ANTfrastructure`) would be false in a repo with no
    `.gitmodules`, so `docs.yml` runs the hub's aggregator directly.
  - **Renovate still gets a wrapper.** No CI lane runs it, so `scripts/linux/renovate-local.sh`
    is the only dependency watch; Dependabot is off (owner, 2026-10-20). User-facing side:
    [docs/getting-started.md § Dependency upgrades](docs/getting-started.md#dependency-upgrades).
- **The wrappers FIND the hub; none assumes one.**
  [`scripts/lib/find-hub.sh`](scripts/lib/find-hub.sh) owns the one ladder, in order:
  1. `--hub`
  2. `$ANTFRASTRUCTURE_DIR`
  3. `./antfrastructure-tools` (what `docs.yml` creates in CI)
  4. `./third_party/ANTfrastructure` (if this repo ever grows the submodule)
  5. `../ANTfrastructure` and `../../ANTfrastructure` (a sibling clone on a dev box)

  A rung counts only if the file the caller named is really inside it; an explicitly wrong
  `--hub` is an error, not something to probe past; a miss prints every path it tried. Never
  retype the ladder into a new script: source that file.
- **The Dart gate formats TRACKED files, never `dart format .`**
  ([hub § *`dart format`: the tracked files*](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/code-quality-tooling.md#dart-format-the-tracked-files-in-the-floors-style)),
  so a new `.dart` file escapes the format check (not `dart analyze` or `flutter test`) until it
  is `git add`ed. `scripts/run-dart-checks.sh` takes no arguments: `--strict false` would turn
  the blocking gate into a warning.
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

`<hub>` is `./antfrastructure-tools` in CI (what the checkout steps in `docs.yml` and
`build-docs.yml` create) and a sibling ANTfrastructure clone locally. The wrappers find it on
their own; the direct calls below pick a different one.

```bash
# The Dart gate CI runs: pub get, pubspec structure, format on tracked files,
# analyze, test
bash scripts/run-dart-checks.sh
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
