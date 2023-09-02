import 'package:hive/hive.dart';

class TokenBox {
  static const String boxName = 'tokenBox';

  Future saveToken (String token) async {
    final box = await Hive.openBox<String>(boxName);
    await box.put('access_token', token);
  }

  Future<String?> getToken () async {
    final box = await Hive.openBox<String>(boxName);
    return box.get('access_token');
  }

  Future deleteToken () async {
    final box = await Hive.openBox<String>(boxName);
    await box.delete("access_token");
  }
}