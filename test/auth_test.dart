import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_app/services/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    return Stream.fromIterable([_mockUser]);
  }
}

void main() {
  final MockFirebaseAuth _mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: _mockFirebaseAuth);
  setUpAll(() {});
  tearDownAll(() {});

  test("User is returned", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });
}
