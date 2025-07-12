class ApiEndpoints {
  ApiEndpoints._();

  static const String serverAddress = "http://192.168.1.111:4000";
  static const String baseUrl = "$serverAddress/api/";

  static const String login = "${baseUrl}auth/login";
  static const String register = "${baseUrl}auth/register";
  static const deepSeekChat = "deepseek-chat";

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
