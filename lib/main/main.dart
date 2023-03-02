import 'package:jambu/app/app.dart';
import 'package:jambu/main/bootstrap/bootstrap.dart';
import 'package:jambu/repository/repository.dart';

void main() {
  bootstrap((firebaseMessaging, firebaseAuth) async {
    final userRepository = UserRepository(firebaseAuth: firebaseAuth);
    return App(userRepository: userRepository);
  });
}
