
import 'package:contact_management/core/local/local_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveUserInformation(LocalUser localUser) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("accessToken", localUser.accessToken!);

  }

  Future<LocalUser> getUserInformation() async {
    final SharedPreferences prefs = await _prefs;
    String accessToken = prefs.getString('accessToken') ?? "";

    return LocalUser(
        accessToken: accessToken);
  }

  Future<void> deleteLocalUser() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("accessToken");
    await prefs.clear();
    String accessToken = prefs.getString('accessToken') ?? 'not found';
  }
}
