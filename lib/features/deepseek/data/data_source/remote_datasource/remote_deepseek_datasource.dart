import 'package:travvie/core/network/api_service.dart';
import 'package:travvie/app/constant/api_endpoints.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_request_model.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_response_model.dart';

abstract class RemoteDeepSeekDataSource {
  Future<DeepSeekResponseModel> generateTrip(DeepSeekRequestModel requestModel);
}

class RemoteDeepSeekDataSourceImpl implements RemoteDeepSeekDataSource {
  final ApiService apiService;

  RemoteDeepSeekDataSourceImpl(this.apiService);

  @override
  Future<DeepSeekResponseModel> generateTrip(
      DeepSeekRequestModel requestModel) async {
    print("[REMOTE] Sending deepseek request...");

    final response = await apiService.dio.post(
      ApiEndpoints.deepSeekChat,
      data: requestModel.toJson(),
    );

    print("[REMOTE] Deepseek API response: ${response.data}");

    if (response.statusCode == 200) {
      return DeepSeekResponseModel.fromJson(response.data);
    } else {
      throw Exception("Failed to generate trip. ${response.data}");
    }
  }
}
