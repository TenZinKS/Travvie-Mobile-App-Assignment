import 'package:dio/dio.dart';
import 'package:travvie/core/network/api_service.dart';
import 'package:travvie/core/network/token_provider.dart';
import 'package:travvie/features/trip/data/model/trip_model.dart';

abstract class TripRemoteDataSource {
  Future<void> addTrip(TripModel trip);
  Future<List<TripModel>> getAllTrips();
  Future<void> updateTrip(TripModel trip);
  Future<void> deleteTrip(String tripId);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final ApiService api;

  TripRemoteDataSourceImpl(this.api);

  Future<Map<String, String>> _getAuthHeader() async {
    final token = await TokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token is missing');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<void> addTrip(TripModel trip) async {
    final headers = await _getAuthHeader();
    final userId = await TokenProvider.getUserId(); // ✅ retrieve from Hive

    if (userId == null || userId.isEmpty) {
      throw Exception('User ID is missing');
    }

    final body = {
      "from": trip.from,
      "destination": trip.to,
      "numberOfPeople": trip.numberOfPeople,
      "startDate": trip.startDate?.toIso8601String(),
      "endDate": trip.endDate?.toIso8601String(),
      "itinerary": trip.itinerary,
      "status": trip.status,
      "userId": userId,
    };

    await api.dio.post(
      "/trips",
      data: body,
      options: Options(headers: headers),
    );
  }

  @override
  Future<List<TripModel>> getAllTrips() async {
    final headers = await _getAuthHeader();
    final userId = await TokenProvider.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID is missing');
    }

    final response = await api.dio.get(
      "/trips/user/$userId",
      options: Options(headers: headers),
    );

    return (response.data as List)
        .map((json) => TripModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    final headers = await _getAuthHeader();

    await api.dio.put(
      "/trips/${trip.id}", // ✅ here id is tripId
      data: trip.toJson(),
      options: Options(headers: headers),
    );
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    final headers = await _getAuthHeader();

    await api.dio.delete(
      "/trips/$tripId",
      options: Options(headers: headers),
    );
  }
}
