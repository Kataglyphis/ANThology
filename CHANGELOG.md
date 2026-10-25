# Changelog

## [Unreleased]

- 2026-10-25: verify the Renovate wrapper and shared config in CI without applying updates.
- 2026-10-25: add shared size, complexity, duplication and submodule-pin checks to CI;
  generated local reports stay in ignored `logs/`.
- 2026-10-22: keep one router across theme, language and breakpoint changes, update pages through
  `AppAttributesScope`, and dispose the router with the shell. Bottom navigation reports its
  selection consistently with the rail. Retained Markdown, skills and CSV widgets refresh changed
  asset inputs; locale variants such as `de_AT` load German Markdown.
- 2026-10-22: `FileActions` opens and saves bundled files on native platforms instead of throwing
  from enabled buttons. Browser actions use the asset prefix in debug and release; failures show
  localized feedback. Native extraction and actual button taps have regression tests.
- 2026-10-22: `packages/anthology_test_support` supplies both apps' layout and navigation
  contracts as a dev dependency. Remove unused direct Markdown/highlighter and mock dependencies.

- 2026-10-21: `MarkdownFilePage` shows a Markdown image by the asset it names: relative to the
  file, else under `imageDirectory` by path or by name (`resolveMarkdownImage`,
  `withResolvedImages`). The `imageDirectory` it took went unused, so the AI blog's
  `../../images/aiBlog/...` and a review's bare `ScreenshotWorleyNoise.png` were fetched from
  `/images/` and `/assets/` and 404ed on jonasheinle.de. `markdown_assets_test.dart` fails a
  shipped page that names an image this package does not bundle.

- 2026-10-21: the README header shows ANThology's own logo, `images/logo.svg`: an ant in an app
  window with a phone behind it, from the family set DocumANTation's `scripts/make_repo_logos.py`
  draws. `images/logo.png`, `assets/images/logo.png` and `assets/icons/faviconNew.ico` (16 to
  256 px) are rendered from it.

- 2026-10-21: CI runs the suite in Chrome too: `docs.yml`'s `checks` job runs
  `scripts/run-dart-checks.sh --test-platform chrome` after the VM run, so the web halves of
  `lib/Boot/` and `lib/Sqlite/` are tested where they run: `boot_overlay_web_test.dart`, and the
  new `sqlite_web_test.dart`, in which the web loader, the self test and the healthcheck name
  `sqlite3.wasm` when the page serves none. `run-dart-checks.sh` takes `--test-platform
  <vm|chrome>`, its only argument. `footer_and_skills_test.dart` is `@TestOn('vm')`: its
  `setUpAll` loads Roboto through `rootBundle`, which a browser test does not serve.

- 2026-10-21: what OmniAccelerANT and jotrockenmitlocken each kept for themselves now lives here,
  so both apps use one copy:
  - `dismissBootOverlay()` (`lib/Boot/`) fades out and removes the loading overlay of the shared web
    shell (ANTfrastructure `shared/web/`). jotrockenmitlocken's JavaScript timer could remove the
    overlay before Flutter was ready.
  - `lib/Sqlite/`: `loadSqlite3`, `runSqliteHealthcheck` and `Sqlite3HealthcheckWidget`, from
    OmniAccelerANT. The IndexedDB name is a parameter, and the strings are in en/de/fr. The
    self-test runs on the same loader; its web error names where `sqlite3.wasm` is served. The
    three `sqlite_self_test_impl_*` files are gone.
  - `isGermanLocale`/`localizedValue` and `UserSettings.aboutMeFileFor`. jotrockenmitlocken
    compared the whole locale, so `de_AT` got English.
  - `defaultFooterPageConfigs()`, the seven footer pages both apps listed.
  - `RoutesCreator`: `getFooter` by default, plus `pairPagesWithConfigs`, `footerPagesWithConfigs`
    (the licence route gets `OpenSourceLicensesPage`), `blogPagesWithConfigs`,
    `mediaCriticsPagesWithConfigs` and `errorPagesWithConfigs`.
  - `BlogDependentScreenConfigurations` lists `getAllPagesConfigs()`.
  - `SettingsLoader` and the settings parsers, from jotrockenmitlocken.
  - `loadAnthologyFonts()` for layout tests; `socialNetworksWithoutIcon`.

- 2026-10-20: the imprint and privacy policy, German and English, publish the e-mail
  `contact@jonasheinle.de` as a `mailto:` link, in place of `XX` and a link to `#` (owner). The
  postal address and phone number stay placeholders by owner decision. The imprint copies in the
  two sample blog pages carry the same line.

- 2026-10-20: Dependabot is off (owner: dependency upgrades go only through Renovate as a local
  CLI, ANTfrastructure's `docs/dependency-updates.md`). `.github/dependabot.yml` (pub) is deleted
  and the repository's Dependabot security-update PRs are disabled; Dependabot alerts stay on.
  `renovate.json`, `AGENTS.md` and `docs/getting-started.md` call Renovate the only watch.

- 2026-10-19: the docs site goes through the hub's reusable `build-docs.yml`: `docs.yml`'s new
  `docs` job builds it with `scripts/build-docs.sh` (the family theme, `images/`, and
  `docs/getting-started.md` as `guide-getting-started.html`), adds the hub's `.htaccess` and 404
  page, fails on a dead internal link or anchor, and publishes only a push to `develop` or
  `main`. The Dart checks are their own `checks` job and no longer build docs. Measured in
  `:latest`: 1071 documents, 0 link findings.

- 2026-10-19: the docs link the hub where they restated it (Renovate's `--apply`, the Dart
  format scope), and the lint gates' `doc-dupes --against-hub` is on (`doc-dupes-hub.allow`).
  Corrected: dependabot watches pub, so Renovate is the only watch over the actions, not over
  everything; the hub aggregator has more than six lint gates.

- 2026-10-19: the README is a short overview in the family's shape (owner: every README links
  into `docs/` for the rest). Prerequisites, the Dart gate, the tips and the Renovate wrapper's
  commands move to `docs/getting-started.md`; contributing, licence and contact are the family
  page's. The README's links into this repo are absolute, since `dart doc` makes it the docs
  site's front page.

- 2026-10-17: the README logo, `assets/images/logo.png` and `assets/icons/faviconNew.ico` are the
  family's ant (owner: one icon in every repository).

- 2026-10-15: `AnthologyTable`, the sortable table behind the books, films, games and quotes
  lists and the blog overview, sorts the way its header arrow points. A header tap sorted with
  the direction from before the tap, so the first tap on a column put it in reverse; on a table
  sorted on load (`sortOnLoaded`) a tap on another column only flipped the load column, since
  every rebuild sorted that one again; and two cells with the same text in one row, two empty
  ones say, both took the first one's width and kind. The table now sorts a copy by the column
  and direction last chosen and never reorders the caller's list. `BlockEntryList` defaulted to
  sorting by a fourth column its three-cell entries do not have. `anthology_table_test.dart`
  covers each case, `CsvDataList`'s loading and its error, and fails 3 of 7 against the old table.

- 2026-10-14: The app no longer rebuilds itself on every resize or keyboard. `KataglyphisAppShell`
  read `MediaQuery.of`, so an open keyboard or any window size change built a new binding and
  a new `GoRouter`, which dropped every page's state: open panels closed, fetched data reloaded,
  and on a phone a text field's keyboard could close itself. It now reads `MediaQuery.sizeOf`
  and keeps its router until a layout breakpoint, the language, the brightness or the colour
  changes; `app_shell_test.dart` resizes within a breakpoint and opens a keyboard without a
  second router.

- 2026-10-13: An HTML comment in a Markdown page no longer shows. markdown_widget printed
  `<!-- Telefon: 030 18 305-0 -->` as text on the Impressum in both languages and on the
  two blog pages that repeat it, the number its author had commented out.
  `MarkdownFilePage` strips comments before rendering, except inside fenced code, and
  `markdown_assets_test.dart` fails any shipped page that would still show one, an
  unclosed comment included.

- 2026-10-13: Roboto's Medium Italic face goes, 92 kB of every cold load of both
  consumers (Flutter web fetches every declared face before the first frame). Nothing
  sets italic in code, and no Markdown file puts emphasis in a heading, the only place
  weight 500 meets italic; body emphasis keeps Italic, `**_bold italic_**` keeps
  BoldItalic. OmniAccelerANT's Impressum, which has both, is pixel-identical before and
  after at 1280 and 360 px.

- 2026-10-13: `CacheHeight` and its `RenderCacheHeight` go, 61 lines in two files: no file
  here, in OmniAccelerANT or in jotrockenmitlocken imported them.

- 2026-10-12: 7.6 MB less in every build of both consumers. The 404 page's animation is
  `error404.webp`: the GIF's 100 frames at 40 ms and 800x600, the size the page shows it
  at, 0.85 MB instead of 4.9 MB (WebP quality 80; mean difference under 1 of 255 per
  channel, and none to see side by side). `funny_programmer.gif` (3.6 MB) goes, as
  jotrockenmitlocken shows the WebP since its ff3978c too. `ErrorPageWidget.imageAsset`
  names the file, and a test decodes all 100 frames from it.

- 2026-10-12: A landing page with an image downloads about 4 MB less. Measured on
  OmniAccelerANT's landing page in headless Chrome as a phone, which moved 9.1 MB cold:
  - `OpenableImage` faded every image in from `Summy&Thundy_compressed.png`, a 766 kB
    photo fetched only to be replaced. It fades in from a 1x1 transparent pixel now;
    `placeholderImage` still takes an asset. The photo stays, as OmniAccelerANT's cat cam
    test finds cats in it.
  - Roboto's Thin, Light and Black faces and their italics go, six files: Material 3
    renders weights 400 and 500, code here and in both consumers names only
    `FontWeight.bold`, and Flutter web fetches every declared face before the first frame.
  - `funny_programmer.webp` is `funny_programmer.gif` at 320 px, 151 frames at 100 ms as
    before: 0.96 MB instead of 3.6 MB, and side by side at the card's size no difference
    shows; the downscale smooths the GIF's dither, which is most of its size.
    OmniAccelerANT shows the WebP; the GIF stays for jotrockenmitlocken until it switches.

- 2026-10-12: Both consumers lay out at 200 % system font, Android's largest. A landing
  page entry's "last changed" line was a `Row` and overflowed a phone by 81 px; it is an
  `Align` now, so the date wraps. The desktop footer's three sections overflowed a 1280 px
  window by 34 px; the row sits in a `FittedBox` that only scales down, because stacking
  the sections as on a phone would make the pinned footer fill the window. At 100 % both
  are pixel-identical to before. The footer test adds 1280 px at 200 %, which fails
  without the `FittedBox`.

- 2026-10-12: Three widgets no consumer uses are gone: `ComponentDecoration`,
  `ScrollableList` and `CopyButton`, with `CopyButton`'s `copyLabel` string in all three
  locales. All three date from the first commit (May 2024); neither OmniAccelerANT nor
  jotrockenmitlocken, nor anything else here, names them. `ComponentGroupDecoration` and
  `FirstComponentList` stay.

- 2026-10-12: The privacy policy and the accessibility statement render as written. A tab
  after a list number (`1. ⇥Title`) puts the text five columns in, which Markdown makes an
  indented code block. Thirteen lines showed as grey code boxes: five titles in the German
  privacy policy, all seven rights in the English one, and the English accessibility
  statement's requirement. The first of seven bullets sat a level above the rest, and
  `markdown_widget` ran a list item's paragraphs together ("ausgeschlossen.Die
  IP-Adresse"). The numbered sections of both privacy policies are `### N. Title` headings
  with plain paragraphs now, with no tab left in the footer pages; every word is unchanged
  except six English rights titles that now start with a capital.
  `test/markdown_assets_test.dart` parses every shipped page and fails on a code block
  without a language, which only indentation produces.

- 2026-10-12: The footer and the landing page lay out at every size the consumers test.
  - A phone with its system font at 150 % overflowed by 77 px in the footer's link rows
    and by 91 px in a landing-page entry's repo line. `AdaptiveGrid` wraps each row in
    an `Align` around a `Wrap`, which keeps the `Row`'s placement in bounded and unbounded
    widths alike, and the repo line is a `Wrap`. At 100 % both are pixel-identical to
    before, on a phone and on a desktop.
  - The desktop footer takes its content's height instead of a fixed 150 px, which cut off
    a fourth row of links, and its liability text is a plain centred `Text`: in a
    `Flexible` inside the desktop footer's unbounded `Row` it never laid out.
  - `test/footer_and_skills_test.dart` pumps the footer at 1280 px, at 360 px and at
    360 px with 150 % text, with the real Roboto and seven links.

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
