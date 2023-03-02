import 'package:chopper/chopper.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/main/bootstrap/bootstrap.dart';
import 'package:jambu/ms_graph/api/interceptor/interceptor.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';

void main() {
  bootstrap((firebaseMessaging, firebaseAuth) async {
    final tokenStorage = InMemoryTokenStorage();

    final userRepository = UserRepository(
      firebaseAuth: firebaseAuth,
      tokenStorage: tokenStorage,
    );

    final msGraphChopperClient = ChopperClient(
      baseUrl: Uri.parse('https://graph.microsoft.com'),
      interceptors: [
        LoggingInterceptor(),
        AuthInterceptor(tokenStorage: tokenStorage),
      ],
    );
    final msGraphAPI = MSGraphAPI.create(msGraphChopperClient);
    final msGraphRepository = MSGraphRepository(msGraphAPI: msGraphAPI);

    return App(
      userRepository: userRepository,
      msGraphRepository: msGraphRepository,
    );
  });
}
