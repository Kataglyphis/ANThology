class AppSettings {
  AppSettings({required this.appNameDe, required this.appNameEn}) {}
  AppSettings.fromJsonFile(Map<String, dynamic> appSettingsJson)
      : appNameDe = appSettingsJson['appNameDe'] as String,
        appNameEn = appSettingsJson['appNameEn'] as String;

  String appNameDe;
  String appNameEn;
}
