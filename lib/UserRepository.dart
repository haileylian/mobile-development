import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class UserRepository {
  static final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();

  static String firstName = '';
  static String lastName = '';
  static String phoneNumber = '';
  static String email = '';

  static Future<void> loadData() async {
    try {
      firstName = await _preferences.getString('firstName') ?? '';
      lastName = await _preferences.getString('lastName') ?? '';
      phoneNumber = await _preferences.getString('phoneNumber') ?? '';
      email = await _preferences.getString('email') ?? '';
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  static Future<void> saveData() async {
    try {
      await _preferences.setString('firstName', firstName);
      await _preferences.setString('lastName', lastName);
      await _preferences.setString('phoneNumber', phoneNumber);
      await _preferences.setString('email', email);
    } catch (e) {
      print('Error saving data: $e');
    }
  }
}