import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/features/trip/presentation/view/trip_screen.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_bloc.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_event.dart';
import 'package:travvie/features/trip/presentation/view_model/trip_state.dart';
import 'package:travvie/features/trip/domain/entity/trip_entity.dart';

class MockTripBloc extends Mock implements TripBloc {}

void main() {
  late MockTripBloc mockTripBloc;

  setUp(() {
    mockTripBloc = MockTripBloc();
  });

  Widget createWidgetUnderTest(TripState state) {
    when(() => mockTripBloc.state).thenReturn(state);
    whenListen(mockTripBloc, Stream.fromIterable([state]));

    return MaterialApp(
      home: BlocProvider<TripBloc>.value(
        value: mockTripBloc,
        child: const TripScreen(),
      ),
    );
  }

  testWidgets('Displays loading indicator when state is TripLoading', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest(TripLoading()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays error message when state is TripError', (tester) async {
    const errorMessage = 'Something went wrong';
    await tester.pumpWidget(createWidgetUnderTest(const TripError(errorMessage)));
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Displays trip cards when state is TripLoaded', (tester) async {
    final trips = [
      TripEntity(
        id: '1',
        from: 'Kathmandu',
        to: 'Pokhara',
        numberOfPeople: 2,
        itinerary: 'Visit lakes and mountains',
        startDate: DateTime(2025, 9, 1),
        endDate: DateTime(2025, 9, 5),
        status: 'PLANNED',
      ),
      TripEntity(
        id: '2',
        from: 'Lalitpur',
        to: 'Chitwan',
        numberOfPeople: 3,
        itinerary: 'Safari and fun',
        startDate: DateTime(2025, 10, 10),
        endDate: DateTime(2025, 10, 15),
        status: 'UPCOMING',
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(TripLoaded(trips)));
    await tester.pumpAndSettle();

    expect(find.textContaining('Kathmandu'), findsOneWidget);
    expect(find.textContaining('Chitwan'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(trips.length));
  });
}
