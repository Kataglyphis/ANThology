# Changelog

## [Unreleased]

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
