import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static const uidKey = 'uuvgauwvasd';
  static const eKey = 'sndabwiefabwe';
  static const nKey = 'nuawgugawgj';
  static const pKey = 'sadarbhvarev';
  static const rKey = 'awnfiawiufjkdsb';
  static const mKey = 'niaiewiaiuea';
  static const gKey = 'awbiaiubvabeva';
  static const dKey = ' ajbvuabawebjkwe';

  static Future<bool> saveUserId(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(uidKey, uid);
  }

  //gets uid of user
  static Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(uidKey);
  }

  static Future<bool> saveEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(eKey, email);
  }

  //gets email of user
  static Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(eKey);
  }

  static Future<bool> saveName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nKey, name);
  }

  //gets name of user
  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nKey);
  }

  static Future<bool> saveMobile(String mobile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(mKey, mobile);
  }

  //gets mobile of user
  static Future<String?> getMobile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(mKey);
  }

  static Future<bool> saveRole(String role) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(rKey, role);
  }

  //gets role of user
  static Future<String?> getRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(rKey);
  }

  static Future<bool> saveGender(String gender) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(gKey, gender);
  }

  //gets gender of user
  static Future<String?> getGender() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(gKey);
  }

  static Future<bool> saveAge(String dob) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(dKey, dob);
  }

  //gets age of user
  static Future<String?> getAge() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(dKey);
  }

  //   delete all the data for logout
  static Future<void> clearUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
