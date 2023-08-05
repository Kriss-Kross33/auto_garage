// ignore_for_file: prefer_const_constructors
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    const id = 'mock-id';
    const email = 'mock-email';

    test('uses value equality', () {
      expect(
        UserModel(email: email, id: id, isAnonymous: false),
        equals(UserModel(email: email, id: id, isAnonymous: false)),
      );
    });

    test('isEmpty returns true for empty user', () {
      expect(UserModel.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty user', () {
      final user = UserModel(email: email, id: id, isAnonymous: false);
      expect(user.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty user', () {
      expect(UserModel.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty user', () {
      final user = UserModel(email: email, id: id, isAnonymous: false);
      expect(user.isNotEmpty, isTrue);
    });
  });
}
