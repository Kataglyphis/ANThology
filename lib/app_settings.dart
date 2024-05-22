class AppSettings {
  AppSettings({
    required this.appNameDe,
    required this.appNameEn,
    required this.appTitleDe,
    required this.appTitleEn,
    //this.supportedLocales
  }) {}
  AppSettings.fromJsonFile(Map<String, dynamic> appSettingsJson)
      : appNameDe = appSettingsJson['appNameDe'] as String,
        appNameEn = appSettingsJson['appNameEn'] as String,
        appTitleDe = appSettingsJson['appTitleDe'] as String,
        appTitleEn = appSettingsJson['appTitleEn'] as String {
    List<dynamic> supportedLocalesAsJsonMap =
        appSettingsJson['supportedLocales'] as List<dynamic>;
    supportedLocales =
        supportedLocalesAsJsonMap.map((element) => element.toString()).toList();
  }

  String appNameDe;
  String appNameEn;
  String appTitleDe;
  String appTitleEn;
  List<String>? supportedLocales;
}
