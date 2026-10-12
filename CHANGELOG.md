# Changelog

## [Unreleased]

- 2026-10-12: Three frontend fixes both consumers get with their next pin.
  - The footer showed GitHub and no other social icon. Flutter's icon tree shaking keeps
    only the glyphs it finds in constants, and `socialMediaIcons` was a `final` map, so a
    web build's Font Awesome brands subset held GitHub alone, which
    `landing_page_entry.dart` names directly. The map is `const` now, and a test fails if
    it stops being one.
  - `SkillTable` stacks each title above its list at 450 px and narrower, where two equal
    columns broke "Programmiersprachen" mid-word.
  - The footer's liability text is centred and wraps, and the copyright reads
    2024–<this year> through a `{years}` placeholder (`copyrightYears`).
- 2026-10-12: Montserrat is gone, 18 declared faces and 4.3 MB of files. No code
  here or in either consumer ever named `packages/anthology/Montserrat`, yet
  Flutter web downloads every font a manifest declares before the first frame, so
  each consumer's web build fetched about 1.6 MB of it on every cold load.
  jotrockenmitlocken's `web/css/cookie.css` asks for `"Montserrat"`, but CSS never
  saw these files: no `@font-face` names them, and Flutter's renderers load
  manifest fonts into their own font collection, not `document.fonts`. Roboto, the
  theme font, stays complete.
- 2026-09-25: `docs.yml` checks the hub out at `ref: develop` and calls its
  actions at `@develop`; hub `main` is a release branch that lags it. README.md
  and AGENTS.md follow, and link the hub's docs at `develop`. Three stale claims
  in them are corrected: `renovate-local.sh --apply` does rewrite
  `pubspec.yaml`, the Dart gate also checks pubspec structure, and the README
  no longer suggests `flutter build linux` in a package that has no runner.
- 2026-09-24: `.github/workflows/dart.yml` is `docs.yml`, display name
  "Docs · deploy" — the family's workflow naming convention (owner decision:
  kebab-case files, shared lanes named alike in every repo, `<Area> · <what>`).
  Triggers, jobs and job ids are unchanged; the README badge follows the file.
- The doc-link gate's five findings over this tree are fixed, not frozen — it
  has no freeze file. `aiBlogPageEn.md` named `ScreenshotWorleyNoise.png` beside
  itself, where no copy has ever existed; it now points at
  `assets/images/aiBlog/`, the copy 2.0.0 kept. The other four named hub pages
  (`docs/ftp-deploys.md`, `docs/consumer-image-contract.md`,
  `docs/dependency-updates.md` twice) as if they were this repo's, which has no
  `docs/` tree and no hub submodule to resolve them against; they are hub URLs
  now.

## [2.0.0]

- **Breaking.** The data table is named after the package rather than after one
  of its two consumers: `JotrockenmitlockenTable`, `JotrockenmitlockenTableState`
  and `JotrockenmitlockenTableInfoProvider` are now `AnthologyTable`,
  `AnthologyTableState` and `AnthologyTableInfoProvider`, in
  `lib/Media/DataTable/anthology_table{,_info_provider}.dart`.
- **Breaking for anything that loaded them by path.** The unreferenced
  personal-site assets are gone: four of the five `Bewerbungsbilder` portraits,
  `assets/images/Pages/Blog/` (the OpenGLRenderer and VulkanRenderer
  screenshots), `assets/videos/`, two cat images, the PayPal QR code and the
  barbell icon and image. Every one was in both app bundles and named by
  neither. `pubspec.yaml` declares the one portrait that IS used instead of its
  directory.
- `scripts/run-dart-checks.sh`: the Dart gate as one command, so the check that
  blocks the deploy can be run locally. `scripts/renovate-local.sh` moved to
  `scripts/linux/renovate-local.sh`, and both wrappers now share the hub lookup
  in `scripts/lib/find-hub.sh`.
- The lint gates moved into `dart.yml` as a `lint` job the deploy `needs:`, run
  `--ratchets`, and both jobs now also run on pull requests. `lint-gates.yml` is
  gone; the deploy step is `push`-only.

## [1.1.0]

- l10n: the package ships its own English, German and French catalogues
  (`lib/l10n`, generated Dart committed; `flutter gen-l10n` after editing an
  `.arb`). The `String Function(BuildContext)` closures the apps used to pass in
  are gone.
- The shared asset corpus both apps load: the assets, fonts and legal texts that
  OmniAccelerANT and jotrockenmitlocken carried as byte-identical copies now
  live here, referenced as `packages/anthology/...`; fonts are declared under
  `flutter:` and register as `packages/anthology/<family>`.
- ContainerHub renamed to ANTfrastructure everywhere the hub is named.
- `scripts/renovate-local.sh`: the family's Renovate CLI, reachable without a
  hub submodule — the wrapper finds an ANTfrastructure checkout instead of
  assuming one.
