import 'package:flutter_bloc/flutter_bloc.dart';
import 'deepseek_event.dart';
import 'deepseek_state.dart';
import '../../domain/use_case/generate_trip.dart';

class DeepSeekBloc extends Bloc<DeepSeekEvent, DeepSeekState> {
  final GenerateTrip generateTrip;

  DeepSeekBloc(this.generateTrip) : super(DeepSeekInitial()) {
    on<GenerateTripEvent>(_onGenerateTrip);
  }

  Future<void> _onGenerateTrip(
    GenerateTripEvent event,
    Emitter<DeepSeekState> emit,
  ) async {
    emit(DeepSeekLoading());
    final result = await generateTrip(event.prompt);

    result.fold(
      (failure) => emit(DeepSeekError(failure.message)),
      (response) => emit(DeepSeekLoaded(response)),
    );
  }
}
