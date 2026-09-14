<div align="center">
  <a href="https://jonasheinle.de">
    <img src="images/logo.png" alt="logo" width="200" />
  </a>

  <h1>anthology 📖 📚 </h1>

  <h4>Reusable dart code provided as a package for building beautiful cross-platform apps.  
      Give your project a huge kickstart by using this repo as a starting point.  </h4>
</div>

For official docs follow this [link](https://omnifronteer.jonasheinle.de/) 

[![Deploy docs on website](https://github.com/Kataglyphis/ANThology/actions/workflows/dart.yml/badge.svg)](https://github.com/Kataglyphis/ANThology/actions/workflows/dart.yml)[![CodeQL](https://github.com/Kataglyphis/ANThology/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/Kataglyphis/ANThology/actions/workflows/github-code-scanning/codeql)
[![TopLang](https://img.shields.io/github/languages/top/Kataglyphis/ANThology)]() 
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/JonasHeinle)
[![Twitter](https://img.shields.io/twitter/follow/Cataglyphis_?style=social)](https://twitter.com/Cataglyphis_)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UC3LZiH4sZzzaVBCUV8knYeg?style=social)](https://www.youtube.com/channel/UC3LZiH4sZzzaVBCUV8knYeg)

## Table of Contents
- [About The Project](#about-the-project)
  - [Key Features](#key-features)
  - [Dependencies](#dependencies)
    - [What is behind: Renovate as a local CLI](#what-is-behind-renovate-as-a-local-cli)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Tipps](#tipps)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

<!-- ABOUT THE PROJECT -->
## About The Project

The aim of this project is to leverage other projects in their needs for
native UI development (Linux/Windows/Web/Android/iOS).</br>
Ships English, German and French catalogues (`lib/l10n`; `flutter gen-l10n`).

### Projects using this projects
* By using this repo my personal web blog [jonasheinle.de](https://jonasheinle.de) is able to build a beautiful web native responsive app 
( see my repo [jotrockenmitlocken](https://github.com/Kataglyphis/jotrockenmitlocken/))
* My [OmniAccelerANT](https://github.com/Kataglyphis/OmniAccelerANT/) uses this package for multi-platform 
  UI support when running AI :smile:

### Key Features

<div align="center">

|         Category                  |                 Feature                                      |  Implement Status  |
|---------------------------------------|-------------------------------------------------------------|:------------------:|
|  **Layout**                      | Easy cross-platform layout creation    |         ✔️         |
|  **Media & Files**          | Media handling (open, download)        |         ✔️         |
|                                            | Image handling                                        |         ✔️         |
|  **Rendering**                | Markdown rendering                               |         ✔️         |
|                                            | Responsive table creation                      |         ✔️         |
|  **UI Elements**             | Widget decoration                                    |         ✔️         |
|                                            | Social Media Icons                                  |         ✔️         |
|  **Communication**       | EMail handling                                        |         ✔️         |

</div>

**Legend:**  
- ✔️ – completed  
- 🔶 – in progress  
- ❌ – not started


### Dependencies
Watch the `pubspec.yaml` file.

#### What is behind: Renovate as a local CLI

`.github/renovate.json` is read by exactly one thing — the shared Renovate CLI,
run locally. The Renovate GitHub App is installed on no repo in this family and
will not be, and no workflow runs this script, so it blocks nothing and nobody
runs it for you.

```sh
bash scripts/renovate-local.sh                       # report (managers detected from the tree)
bash scripts/renovate-local.sh --hub ../ANTfrastructure # if it cannot find the hub
bash scripts/renovate-local.sh --managers pub        # narrow it
```

**This repo has no `third_party/ANTfrastructure`**, unlike its siblings — the
workflows check the tooling out in CI at `ref: main`. The wrapper therefore has
to *find* a ANTfrastructure checkout instead of assuming one: `--hub`, then
`$ANTFRASTRUCTURE_DIR`, then `./antfrastructure-tools` (what CI creates), then
`./third_party/ANTfrastructure`, then `../ANTfrastructure`. When none of them holds
the tool it prints every path it tried and the `git clone` that fixes it — it
never fails as a bare "command not found".

Run it from WSL on a Windows box; it bootstraps a pinned, checksum-verified Node
and Renovate on first use. The GitHub-actions half needs a token to answer in
full and warns when it has none — `GITHUB_COM_TOKEN="$(gh auth token)"` is what
turns the pub-only report into the whole one (measured 2026-09-09: one row
without, five with). There is nothing to `--apply` here: that half moves
submodule gitlinks, and this repo has none. `pubspec.yaml` stays a hand edit.
Full rationale lives in
[ANTfrastructure's `docs/dependency-updates.md`](https://github.com/Kataglyphis/ANTfrastructure/blob/main/docs/dependency-updates.md).

<!-- ### Useful tools -->

<!-- * [cppcheck](https://cppcheck.sourceforge.io/) -->

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites
[Install Flutter/Dart](https://docs.flutter.dev/get-started/install)

### Installation

1. Clone the repo
   ```sh
   git clone git@github.com:Kataglyphis/ANThology.git
   ```

<!-- ## Tests -->

### Tipps 
If strange things happen try this steps:
```sh
flutter clean
flutter pub get
flutter build linux
```

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License
MIT
<!-- CONTACT -->
## Contact
 
Jonas Heinle - [@Cataglyphis_](https://twitter.com/Cataglyphis_) </br>
Get in touch: contact@jonasheinle.de

Project Link: [https://github.com/Kataglyphis/ANThology](https://github.com/Kataglyphis/ANThology)
