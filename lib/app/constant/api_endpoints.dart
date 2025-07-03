class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  static const String serverAddress = "http://192.168.1.111:3000";
  static const String baseUrl = "$serverAddress/api/v1/";

  static const String login = "auth/login";
  static const String register = "auth/register";


}
