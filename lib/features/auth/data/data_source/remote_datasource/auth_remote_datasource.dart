import 'package:travvie/app/constant/api_endpoints.dart';
import 'package:travvie/core/network/api_service.dart' show ApiService;
import 'package:travvie/features/auth/data/model/login_response_model.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> loginUser(String email, String password);
  Future<void> registerUser(UserEntity user);

  /// ✅ NEW: Delete user from API using user ID
  Future<void> deleteUser(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<LoginResponseModel> loginUser(String email, String password) async {
    print('[REMOTE] Calling remote login with $email');

    final response = await _apiService.dio.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    print('[REMOTE] Login response: ${response.data}');

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      final message = response.data['message'] ?? 'Login failed';
      throw Exception(message);
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    print('[REMOTE] Calling remote register with ${user.email}');

    final response = await _apiService.dio.post(
      ApiEndpoints.register,
      data: {
        'email': user.email,
        'password': user.password,
      },
    );

    print('[REMOTE] Register response: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      final message = response.data['message'] ?? 'Registration failed';
      throw Exception(message);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    print('[REMOTE] Deleting user with ID $userId');

    final response = await _apiService.dio.delete(
      "${ApiEndpoints.baseUrl}/auth/$userId",
    );

    if (response.statusCode != 200) {
      final msg = response.data['msg'] ?? 'User deletion failed';
      throw Exception(msg);
    }

    print('[REMOTE] User deleted from remote API.');
  }
}
