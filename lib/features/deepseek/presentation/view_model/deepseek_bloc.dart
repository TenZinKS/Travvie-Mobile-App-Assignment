import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travvie/features/deepseek/data/model/deepseek_request_model.dart';
import 'package:travvie/features/deepseek/domain/use_case/generate_trip.dart';
import 'package:travvie/features/deepseek/domain/entity/deepseek_response_entity.dart';

part 'deepseek_event.dart';
part 'deepseek_state.dart';

class DeepSeekBloc extends Bloc<DeepSeekEvent, DeepSeekState> {
  final GenerateTrip generateTrip;

  DeepSeekBloc(this.generateTrip) : super(DeepSeekInitial()) {
    on<GenerateTripEvent>(_onGenerateTrip);
  }

  Future<void> _onGenerateTrip(
      GenerateTripEvent event, Emitter<DeepSeekState> emit) async {
    emit(DeepSeekLoading());

    final result = await generateTrip(event.requestModel);

    result.fold(
      (failure) => emit(DeepSeekFailure(failure.message)),
      (response) => emit(
        DeepSeekSuccess(
          request: event.requestModel,
          response: response,
        ),
      ),
    );
  }
}
