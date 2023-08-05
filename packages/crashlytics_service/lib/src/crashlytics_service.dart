import 'package:firebase_crashlytics/firebase_crashlytics.dart';

///{@template}
class CrashlyticsService {
  ///{@macro crashlytics_service}
  const CrashlyticsService({required FirebaseCrashlytics crashlytics})
      : _crashlytics = crashlytics;

  ///
  final FirebaseCrashlytics _crashlytics;

  // Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
  // static const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
  // static const _kTestingCrashlytics = true;

// await runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
//     runApp(MyApp());
//   }, (error, stackTrace) {
//     FirebaseCrashlytics.instance.recordError(error, stackTrace);
//   });

  /// Initialize crashlytics
  Future<void> initalizeCrashlytics() async {}

  /// call method to force the app to crash.
  void simulateTestCrash() {
    _crashlytics.crash();
  }

  /// set crashlytics collection enabled
  Future<void> setCrashlyticsCollectionEnabled() async {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting.

    await _crashlytics.setCrashlyticsCollectionEnabled(true);
  }

  /// add user id to reports
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// add user email to reports
  Future<void> setUserEmail(String email) async {
    await _crashlytics.setCustomKey('email', email);
  }

  /// add user device model to reports
  Future<void> setUserDeviceModel(String deviceModelName) async {
    await _crashlytics.setCustomKey('email', deviceModelName);
  }

  /// Force the app to crash. Do not call this in production.
  void simulateCrash() {
    _crashlytics.crash();
  }

  ///
  Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace,
    String reason,
  ) async {
    await _crashlytics.recordError(error, stackTrace, reason: reason);
  }
}
