import 'package:jambu/app/app.dart';
import 'package:jambu/login/login.dart';
import 'package:jambu/main/bootstrap/bootstrap.dart';

void main() {
  bootstrap((firebaseMessaging, firebaseAuth) async {
    final loginRepository = LoginRepository(firebaseAuth: firebaseAuth);
    return App(loginRepository: loginRepository);
  });
}
