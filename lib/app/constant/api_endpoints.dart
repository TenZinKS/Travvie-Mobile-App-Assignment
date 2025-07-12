class ApiEndpoints {
  ApiEndpoints._();

  static const String serverAddress = "http://192.168.1.111:4000";
  static const String baseUrl = "$serverAddress/api/";

  static const String login = "${baseUrl}auth/login";
  static const String register = "${baseUrl}auth/register";
  static const String deepSeekChat = "deepseek-chat";
  static const String generateTrip = "deepseek-chat/generateTrip";
  
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);
}
