import 'package:flutter_test/flutter_test.dart';
import 'package:travvie/features/auth/domain/entity/user_entity.dart';

void main() {
  test('UserEntity props comparison works as expected', () {
    const user1 = UserEntity(
      id: '123',
      email: 'email@test.com',
      password: 'secret',
      profilePic: 'profile.jpg',
      isAdmin: true,
    );

    const user2 = UserEntity(
      id: '123',
      email: 'email@test.com',
      password: 'secret',
      profilePic: 'profile.jpg',
      isAdmin: true,
    );

    expect(user1, equals(user2));
  });
}
