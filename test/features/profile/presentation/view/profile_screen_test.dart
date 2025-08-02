import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:travvie/app/service_locator/service_locator.dart';
import 'package:travvie/core/network/hive_service.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';
import 'package:travvie/features/auth/domain/repository/auth_local_repository.dart';
import 'package:travvie/features/profile/presentation/view/profile_screen.dart';
import 'package:travvie/features/profile/presentation/view_model/profile_cubit.dart';

class MockProfileCubit extends Mock implements ProfileCubit {}

class MockAuthLocalRepository extends Mock implements AuthLocalRepository {}

class MockHiveService extends Mock implements HiveService {}

class FakeUserEntity extends Fake implements UserEntity {}

void main() {
  late MockProfileCubit mockCubit;
  late MockAuthLocalRepository mockAuthLocalRepository;
  late MockHiveService mockHiveService;

  setUpAll(() {
    registerFallbackValue(FakeUserEntity());
  });

  setUp(() {
    mockCubit = MockProfileCubit();
    mockAuthLocalRepository = MockAuthLocalRepository();
    mockHiveService = MockHiveService();

    // ✅ Register mocks in GetIt
    sl.reset();
    sl.registerLazySingleton<ProfileCubit>(() => mockCubit);
    sl.registerLazySingleton<AuthLocalRepository>(() => mockAuthLocalRepository);
    sl.registerLazySingleton<HiveService>(() => mockHiveService);
  });

  testWidgets('displays profile elements correctly', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthLocalRepository.getCurrentUserEmail()).thenReturn('test@example.com');
    when(() => mockHiveService.getProfileImagePath(any())).thenAnswer((_) async => null);

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('tapping Change Password without user shows snackbar', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthLocalRepository.getCurrentUserEmail()).thenReturn(null);
    when(() => mockHiveService.getProfileImagePath(any())).thenAnswer((_) async => null);

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap "Change Password"
    await tester.tap(find.text('Change Password'));
    await tester.pump(); // to show snackbar

    // Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text("No user logged in."), findsOneWidget);
  });
}
