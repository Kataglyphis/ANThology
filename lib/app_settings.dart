class AppSettings {
  AppSettings({
    required this.appNameDe,
    required this.appNameEn,
    required this.appTitleDe,
    required this.appTitleEn,
    required this.disableFooter,
    //this.supportedLocales
  });
  AppSettings.fromJsonFile(Map<String, dynamic> appSettingsJson)
    : appNameDe = appSettingsJson['appNameDe'] as String,
      appNameEn = appSettingsJson['appNameEn'] as String,
      appTitleDe = appSettingsJson['appTitleDe'] as String,
      appTitleEn = appSettingsJson['appTitleEn'] as String,
      disableFooter = appSettingsJson['disableFooter'] as bool {
    List<dynamic> supportedLocalesAsJsonMap =
        appSettingsJson['supportedLocales'] as List<dynamic>;
    supportedLocales = supportedLocalesAsJsonMap
        .map((element) => element.toString())
        .toList();
  }

  String appNameDe;
  String appNameEn;
  String appTitleDe;
  String appTitleEn;
  bool disableFooter;
  List<String>? supportedLocales;
}
