import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(String token, String role, String id);

  Future<String?> getToken();

  Future<String?> getRole();

  Future<String?> getId();

  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl(this.secureStorage, this.sharedPreferences);

  @override
  Future<void> saveAuthData(String token, String role, String id) async {
    await secureStorage.write(key: 'auth_token', value: token);
    await sharedPreferences.setString('userId', id);
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
  Future<String?> getId() async {
    return sharedPreferences.getString('userId');
  }

  @override
  Future<void> clearAuthData() async {
    await secureStorage.delete(key: 'auth_token');
    await sharedPreferences.remove('userId');
    await sharedPreferences.remove('role');
  }
}
