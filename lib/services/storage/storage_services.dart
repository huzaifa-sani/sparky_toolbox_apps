import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/route/app_routes.dart';
import '../../utils/log/app_log.dart';
import 'storage_keys.dart';

class LocalStorage {

  LocalStorage._();

  /// SharedPreferences instance
  static SharedPreferences? _preferences;
  static bool isAgree = false;

  /// Initialize SharedPreferences (call once in main)
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    await _loadAllData();
  }

  // d
  /// Get storage instance
  static SharedPreferences get _storage => _preferences!;

  /// Load all saved data from SharedPreferences
  static Future<void> _loadAllData() async {
    isAgree = _storage.getBool(LocalStorageKeys.isAgree) ?? false;
    appLog(isAgree, source: 'LocalStorage');
  }

  /// Save token
  static Future<void> saveIsAgree(bool value) async {
    if (!value) {
      appLog(' isAgree is  : $value');
      return;
    }
    isAgree = value;
    await _storage.setBool(LocalStorageKeys.isAgree, value);
  }
  /// Logout user, clear storage and disconnect socket
  static Future<void> logout() async {
    Get.offAllNamed(AppRoutes.home);
  }
}
