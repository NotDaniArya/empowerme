import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(String token, String role);

  Future<String?> getToken();

  Future<String?> getRole();

  Future<void> clearAuthRole();
}

class AuthLocalDataSource implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSource(this.secureStorage, this.sharedPreferences);

  @override
  Future<void> saveAuthData(String token, String role) async {
    await secureStorage.write(key: 'auth_token', value: token);
    await sharedPreferences.setString('role', role);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  @override
  Future<String?> getRole() async {
    return sharedPreferences.getString('role');
  }

  @override
  Future<void> clearAuthData() async {
    await secureStorage.delete(key: 'auth_token');
    await sharedPreferences.remove('role');
  }
}
