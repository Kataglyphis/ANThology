import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Roboto's Apache-2.0 text, bundled beside the TTFs every consuming app ships.
const String robotoLicenseAsset =
    'packages/anthology/assets/fonts/Roboto/LICENSE.txt';

/// One licence entry for [packages], its text read from [bundle] at [assetKey].
Stream<LicenseEntry> assetLicense(
  AssetBundle bundle,
  List<String> packages,
  String assetKey,
) async* {
  yield LicenseEntryWithLineBreaks(packages, await bundle.loadString(assetKey));
}

/// Adds [assetKey]'s text under [packages] to [LicenseRegistry]; it is read only when a page lists licences.
void registerAssetLicense(
  List<String> packages,
  String assetKey, {
  AssetBundle? bundle,
}) {
  LicenseRegistry.addLicense(
    () => assetLicense(bundle ?? rootBundle, packages, assetKey),
  );
}

bool _anthologyLicensesRegistered = false;

/// Registers the licences of files this package bundles that pub's NOTICES omit; idempotent.
void registerAnthologyLicenses({AssetBundle? bundle}) {
  if (_anthologyLicensesRegistered) {
    return;
  }
  _anthologyLicensesRegistered = true;
  registerAssetLicense(<String>['Roboto'], robotoLicenseAsset, bundle: bundle);
}

/// Lets a test register again after [LicenseRegistry.reset].
@visibleForTesting
void resetAnthologyLicenseRegistration() {
  _anthologyLicensesRegistered = false;
}
