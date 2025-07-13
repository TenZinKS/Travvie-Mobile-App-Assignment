/// lib/app/constant/api_endpoints.dart
library;

class ApiEndpoints {
  ApiEndpoints._();

  static const String serverAddress = "http://192.168.1.111:4000";
  static const String baseUrl = "$serverAddress/api";

  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  static const String deepSeekChat = "$baseUrl/deepseek-chat";
  static const String generateTrip = "$baseUrl/deepseek-chat/generateTrip";

  static const Duration connectionTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 120);
}
