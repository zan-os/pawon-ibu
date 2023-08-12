import 'core/di/core_injection.dart';

class RegisteredInjection {
  static void init() {
    _registerCoreInjection();
  }

  static void _registerCoreInjection() {
    CoreInjection();
  }
}
