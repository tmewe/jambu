import 'package:jambu/app/app.dart';
import 'package:jambu/main/bootstrap/bootstrap.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';

void main() {
  bootstrap((firebaseMessaging, firebaseAuth) async {
    final tokenStorage = InMemoryTokenStorage();

    final userRepository = UserRepository(
      firebaseAuth: firebaseAuth,
      tokenStorage: tokenStorage,
    );

    return App(userRepository: userRepository);
  });
}
