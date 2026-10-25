<div align="center">
  <a href="https://jonasheinle.de">
    <img src="images/logo.svg" alt="ANThology logo: an ant inside an app window, with a phone behind it" width="200" />
  </a>

  <h1>ANThology</h1>

  <h4>Shared Flutter/Dart UI package for the family's cross-platform apps.</h4>
</div>

[![Docs · deploy](https://github.com/Kataglyphis/ANThology/actions/workflows/docs.yml/badge.svg)](https://github.com/Kataglyphis/ANThology/actions/workflows/docs.yml)
[![CodeQL](https://github.com/Kataglyphis/ANThology/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/Kataglyphis/ANThology/actions/workflows/github-code-scanning/codeql)
[![TopLang](https://img.shields.io/github/languages/top/Kataglyphis/ANThology)]()
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/JonasHeinle)
[![Twitter](https://img.shields.io/twitter/follow/Cataglyphis_?style=social)](https://twitter.com/Cataglyphis_)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UC3LZiH4sZzzaVBCUV8knYeg?style=social)](https://www.youtube.com/channel/UC3LZiH4sZzzaVBCUV8knYeg)

[**Docs site**](https://omnifronteer.jonasheinle.de/)

The family's shared Flutter/Dart UI package: page shells, routing, layout, decoration and media
widgets, the localization catalogues and the assets the apps load.
[jotrockenmitlocken](https://github.com/Kataglyphis/jotrockenmitlocken/) (the website
[jonasheinle.de](https://jonasheinle.de)) and [OmniAccelerANT](https://github.com/Kataglyphis/OmniAccelerANT/)
build on it. Targets: Linux, Windows, web, Android, iOS.

## Highlights

- **Layout:** cross-platform page layout.
- **Media and files:** browser downloads, native open/save dialogs and image handling.
- **Application state:** theme, locale and layout changes preserve routes and page state.
- **Rendering:** Markdown and responsive tables.
- **UI elements:** widget decoration, social media icons.
- **Email** handling.
- **Localization:** English, German and French catalogues (`lib/l10n`; `flutter gen-l10n`).

## Quick start

```bash
git clone --branch develop https://github.com/Kataglyphis/ANThology.git
cd ANThology
flutter pub get && flutter test
```

A package has no platform runner: build one of the apps that consume it. Prerequisites, the Dart
gate CI runs and dependency upgrades: [docs/getting-started.md](https://github.com/Kataglyphis/ANThology/blob/develop/docs/getting-started.md).

## Documentation

| Topic | Read |
| --- | --- |
| The API | [omnifronteer.jonasheinle.de](https://omnifronteer.jonasheinle.de/) |
| Getting started: prerequisites, the Dart gate, tips, dependency upgrades | [docs/getting-started.md](https://github.com/Kataglyphis/ANThology/blob/develop/docs/getting-started.md) |
| CI quality reports and submodule pin checks | [Shared quality tooling](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/code-quality-tooling.md) |
| Rules for agents and contributors | [AGENTS.md](https://github.com/Kataglyphis/ANThology/blob/develop/AGENTS.md) |
| Changes | [CHANGELOG.md](https://github.com/Kataglyphis/ANThology/blob/develop/CHANGELOG.md) |

## Contributing and contact

ANThology is one of the [Kataglyphis repositories](https://github.com/Kataglyphis/ANTfrastructure/blob/develop/docs/repository-family.md),
which share one way to contribute and one contact. Licence: MIT, see [LICENSE](https://github.com/Kataglyphis/ANThology/blob/develop/LICENSE).
