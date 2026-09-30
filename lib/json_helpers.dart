/// Strict JSON readers for the settings configs: a missing field throws instead of rendering a blank page.
library;

/// Reads a required [String] field out of [json]; throws [FormatException] if absent or not a string.
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

/// Parses a `docsDesc` array into appendix descriptors; null yields an empty list, a non-list throws.
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
