import 'package:chopper/chopper.dart';
import 'package:jambu/app/app.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/main/bootstrap/bootstrap.dart';
import 'package:jambu/ms_graph/ms_graph.dart';
import 'package:jambu/repository/repository.dart';
import 'package:jambu/storage/storage.dart';

void main() {
  bootstrap((
    firebaseMessaging,
    firebaseAuth,
    firebaseFirestore,
    firebaseStorage,
  ) async {
    final tokenStorage = SecureTokenStorage();

    final photoStorageRepository = PhotoStorageRepository(
      storage: firebaseStorage,
    );

    final notificationsRespository = NotificationsRepository(
      firebaseMessaging: firebaseMessaging,
    );

    final firestoreDatasource = FirestoreDatasource(
      firestore: firebaseFirestore,
    );

    final authRepository = AuthRepository(
      firebaseAuth: firebaseAuth,
      tokenStorage: tokenStorage,
      notificationsRespository: notificationsRespository,
    );

    final msGraphChopperClient = ChopperClient(
      baseUrl: Uri.parse('https://graph.microsoft.com'),
      authenticator: AuthChallengeAuthenticator(
        tokenStorage: tokenStorage,
        authRepository: authRepository,
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

    final userRepository = UserRepository(
      firestoreDatasource: firestoreDatasource,
      authRepository: authRepository,
      msGraphRepository: msGraphRepository,
      photoStorageRepository: photoStorageRepository,
    );

    final firestoreRepository = FirestoreRepository(
      firestoreDatasource: firestoreDatasource,
      userRepository: userRepository,
    );

    final calendarRepository = CalendarRepository(
      firestoreRepository: firestoreRepository,
      userRepository: userRepository,
      msGraphRepository: msGraphRepository,
    );

    return App(
      authRepository: authRepository,
      msGraphRepository: msGraphRepository,
      firestoreRepository: firestoreRepository,
      userRespository: userRepository,
      calendarRepository: calendarRepository,
      photoStorageRepository: photoStorageRepository,
    );
  });
}
