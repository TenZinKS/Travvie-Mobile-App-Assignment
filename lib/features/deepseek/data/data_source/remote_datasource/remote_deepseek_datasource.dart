import 'package:travvie/app/constant/api_endpoints.dart';
import 'package:travvie/features/deepseek/domain/entity/deepseek_response_entity.dart';
import 'package:travvie/core/network/api_service.dart';

abstract class RemoteDeepSeekDataSource {
  Future<DeepSeekResponseEntity> generateTrip(String prompt);
}

class RemoteDeepSeekDataSourceImpl implements RemoteDeepSeekDataSource {
  final ApiService apiService;

  RemoteDeepSeekDataSourceImpl(this.apiService);

  @override
  Future<DeepSeekResponseEntity> generateTrip(String prompt) async {
    final response = await apiService.dio.post(
      ApiEndpoints.deepSeekChat,
      data: {'prompt': prompt},
    );

    if (response.statusCode == 200) {
      return DeepSeekResponseEntity(content: response.data['message'] ?? '');
    } else {
      throw Exception(response.statusMessage ?? 'Failed to generate trip');
    }
  }
}
