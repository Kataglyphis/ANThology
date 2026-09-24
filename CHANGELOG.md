# Changelog

## [Unreleased]

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
