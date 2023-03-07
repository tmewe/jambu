import 'package:chopper/chopper.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/main/bootstrap/bootstrap.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  bootstrap((firebaseMessaging, firebaseAuth, firebaseFirestore) async {
    // TODO(tim): Replace with secure storage
    final sharedPrefs = await SharedPreferences.getInstance();
    final tokenStorage = SharedPrefsTokenStorage(sharedPrefs: sharedPrefs);

    final notificationsRespository = NotificationsRespository(
      firebaseMessaging: firebaseMessaging,
    );

    final userRepository = UserRepository(
      firebaseAuth: firebaseAuth,
      tokenStorage: tokenStorage,
      notificationsRespository: notificationsRespository,
    );

    final firestoreDatasource = FirestoreDatasource(
      firestore: firebaseFirestore,
    );

    final firestoreRepository = FirestoreRepository(
      firestoreDatasource: firestoreDatasource,
    );

    final msGraphChopperClient = ChopperClient(
      baseUrl: Uri.parse('https://graph.microsoft.com'),
      authenticator: AuthChallengeAuthenticator(
        tokenStorage: tokenStorage,
        userRepository: userRepository,
      ),
      interceptors: [
        LoggingInterceptor(),
        AuthInterceptor(tokenStorage: tokenStorage),
      ],
    );
    final msGraphAPI = MSGraphAPI.create(msGraphChopperClient);
    final msGraphDataSource = MSGraphDataSource(msGraphAPI: msGraphAPI);
    final msGraphRepository = MSGraphRepository(
      msGraphDataSource: msGraphDataSource,
    );

    return App(
      userRepository: userRepository,
      msGraphRepository: msGraphRepository,
      firestoreRepository: firestoreRepository,
    );
  });
}
