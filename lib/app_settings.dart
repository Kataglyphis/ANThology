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
        appTitleEn = appSettingsJson['appTitleEn'] as String
  //supportedLocales = appSettingsJson['supportedLocales'] as List<String>?
  ;

  String appNameDe;
  String appNameEn;
  String appTitleDe;
  String appTitleEn;
  //List<String>? supportedLocales;
  //"supportedLocales": ["en", "de"]
}
