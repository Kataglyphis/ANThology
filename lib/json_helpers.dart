/// Shared strict JSON readers for the settings configs.
///
/// Both `BlogPageConfig` and `MyTwoCentsConfig` parse hand-maintained JSON.
/// A silently missing field there produces a page that renders blank, so these
/// helpers throw instead of substituting a default.
library;

/// Reads a required [String] field out of [json].
///
/// Throws [FormatException] when the key is absent or is not a string.
String requireStringField(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    throw FormatException('Missing required field: $key');
  }
  if (value is! String) {
    throw FormatException(
      'Field "$key" must be a String, got ${value.runtimeType}',
    );
  }
  return value;
}

/// Parses a `docsDesc` array into the appendix descriptor list.
///
/// A null [docsDescJson] yields an empty list - appendices are optional.
/// A present but non-list value is a malformed settings file and throws.
List<Map<String, String>> parseDocsDesc(dynamic docsDescJson) {
  final docsDesc = <Map<String, String>>[];
  if (docsDescJson == null) return docsDesc;
  if (docsDescJson is! List) {
    throw FormatException('docsDesc must be a List');
  }
  for (final element in docsDescJson) {
    if (element is! Map) continue;
    docsDesc.add({
      'baseDir': element['baseDir']?.toString() ?? '',
      'title': element['title']?.toString() ?? '',
      'additionalInfo': element['additionalInfo']?.toString() ?? '',
    });
  }
  return docsDesc;
}
