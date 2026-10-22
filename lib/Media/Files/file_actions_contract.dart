/// Actions on an asset key, including `packages/<package>/...` keys.
abstract interface class FileActions {
  Future<void> open(String asset);

  Future<void> save(String asset);
}
