class AppEnv {
  static String getBaseUrl() {
    return const String.fromEnvironment('API_BASE_URL',
        defaultValue: 'http://10.0.2.2:3000');
  }
}
