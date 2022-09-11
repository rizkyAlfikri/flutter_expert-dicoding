import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticTracker {
  static late FirebaseCrashlytics _instance;

  static void init() {
    _instance = FirebaseCrashlytics.instance;
  }

  static void recordCrashEvent(String message) {
    _instance.log(message);
  }
}
