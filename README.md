<div align="center">
  <a href="https://jonasheinle.de">
    <img src="images/logo.png" alt="logo" width="200" />
  </a>

  <h1>jotrockenmitlockenrepo 📖 📚 </h1>

  <h4>Reusable dart code provided as a package for building beautiful cross-platform apps.  
      Give your project a huge kickstart by using this repo as a starting point.  </h4>
</div>

For official docs follow this [link](https://omnifronteer.jonasheinle.de/) 

<!-- [![Linux build](https://github.com/Kataglyphis/GraphicsEngineVulkan/actions/workflows/Linux.yml/badge.svg)](https://github.com/Kataglyphis/GraphicsEngineVulkan/actions/workflows/Linux.yml)
[![Windows build](https://github.com/Kataglyphis/GraphicsEngineVulkan/actions/workflows/Windows.yml/badge.svg)](https://github.com/Kataglyphis/GraphicsEngineVulkan/actions/workflows/Windows.yml)-->
[![Deploy docs on website](https://github.com/Kataglyphis/jotrockenmitlockenrepo/actions/workflows/dart.yml/badge.svg)](https://github.com/Kataglyphis/jotrockenmitlockenrepo/actions/workflows/dart.yml)[![CodeQL](https://github.com/Kataglyphis/jotrockenmitlockenrepo/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/Kataglyphis/jotrockenmitlockenrepo/actions/workflows/github-code-scanning/codeql)
[![TopLang](https://img.shields.io/github/languages/top/Kataglyphis/jotrockenmitlockenrepo)]() 
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/JonasHeinle)
[![Twitter](https://img.shields.io/twitter/follow/Cataglyphis_?style=social)](https://twitter.com/Cataglyphis_)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UC3LZiH4sZzzaVBCUV8knYeg?style=social)](https://www.youtube.com/channel/UC3LZiH4sZzzaVBCUV8knYeg)

## Table of Contents
- [About The Project](#about-the-project)
  - [Key Features](#key-features)
  - [Dependencies](#dependencies)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Tipps](#tipps)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)
- [Literature](#literature)

<!-- ABOUT THE PROJECT -->
## About The Project

The aim of this project is to leverage other projects in their needs for
native UI development (Linux/Windows/Web/Android/iOS).</br>
Supports english and german right now.

### Projects using this projects
* By using this repo my personal web blog [jonasheinle.de](https://jonasheinle.de) is able to build a beautiful web native responsive app 
( see my repo [jotrockenmitlocken](https://github.com/Kataglyphis/jotrockenmitlocken/))
* My [Inference Engine](https://github.com/Kataglyphis/Kataglyphis-Inference-Engine/) uses this package for multi-platform 
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

<!-- ### Useful tools -->

<!-- * [cppcheck](https://cppcheck.sourceforge.io/) -->

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites
[Install Flutter/Dart](https://docs.flutter.dev/get-started/install)

### Installation

1. Clone the repo
   ```sh
   git clone --recurse-submodules git@github.com:Kataglyphis/jotrockenmitlockenrepo.git
   ```

<!-- ## Tests -->

### Tipps 
If strange things happen try this steps:
```sh
flutter clean
flutter pub get
flutter build linux
```

<!-- ROADMAP -->
## Roadmap
Upcoming :)
<!-- See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a list of proposed features (and known issues). -->



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

Project Link: [https://github.com/Kataglyphis/jotrockenmitlockenrepo](https://github.com/Kataglyphis/jotrockenmitlockenrepo)


<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

<!-- Thanks for free 3D Models: 
* [Morgan McGuire, Computer Graphics Archive, July 2017 (https://casual-effects.com/data)](http://casual-effects.com/data/)
* [Viking room](https://sketchfab.com/3d-models/viking-room-a49f1b8e4f5c4ecf9e1fe7d81915ad38) -->

## Literature 

Some very helpful literature, tutorials, etc. 

<!-- CMake/C++
* [Cpp best practices](https://github.com/cpp-best-practices/cppbestpractices)

Vulkan
* [Udemy course by Ben Cook](https://www.udemy.com/share/102M903@JMHgpMsdMW336k2s5Ftz9FMx769wYAEQ7p6GMAPBsFuVUbWRgq7k2uY6qBCG6UWNPQ==/)
* [Vulkan Tutorial](https://vulkan-tutorial.com/)
* [Vulkan Raytracing Tutorial](https://developer.nvidia.com/rtx/raytracing/vkray)
* [Vulkan Tutorial; especially chapter about integrating imgui](https://frguthmann.github.io/posts/vulkan_imgui/)
* [NVidia Raytracing tutorial with Vulkan](https://nvpro-samples.github.io/vk_raytracing_tutorial_KHR/)
* [Blog from Sascha Willems](https://www.saschawillems.de/)

Physically Based Shading
* [Advanced Global Illumination by Dutre, Bala, Bekaert](https://www.oreilly.com/library/view/advanced-global-illumination/9781439864951/)
* [The Bible: PBR book](https://pbr-book.org/3ed-2018/Reflection_Models/Microfacet_Models)
* [Real shading in Unreal engine 4](https://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf)
* [Physically Based Shading at Disney](https://blog.selfshadow.com/publications/s2012-shading-course/burley/s2012_pbs_disney_brdf_notes_v3.pdf)
* [RealTimeRendering](https://www.realtimerendering.com/)
* [Understanding the Masking-Shadowing Function in Microfacet-Based BRDFs](https://hal.inria.fr/hal-01024289/)
* [Sampling the GGX Distribution of Visible Normals](https://pdfs.semanticscholar.org/63bc/928467d760605cdbf77a25bb7c3ad957e40e.pdf)

Path tracing
* [NVIDIA Path tracing Tutorial](https://github.com/nvpro-samples/vk_mini_path_tracer/blob/main/vk_mini_path_tracer/main.cpp) -->

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/jonas-heinle-0b2a301a0/
