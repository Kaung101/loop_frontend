class AppEnv {
  static String getBaseUrl() {
    return const String.fromEnvironment('API_BASE_URL',
        defaultValue: 'http://54.254.8.87:3000');
  }
}
