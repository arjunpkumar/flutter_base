import 'package:flutter_base/src/domain/database/base_hive_dao.dart';
import 'package:hive/hive.dart';

class SettingsDao extends BaseHiveDao {
  static const kUserSecurity = 'user_security';

  Future<Box> getBox() async {
    return Hive.openBox("settings");
  }

  Future<void> setSecurityEnabled(bool value) async {
    final box = await getBox();
    box.put(kUserSecurity, value);
  }

  Future<bool> isSecurityEnabled() async {
    final box = await getBox();
    final value = await box.get(kUserSecurity);
    return (value as bool) ?? true;
  }

  @override
  Future<void> clear() async {
    final box = await getBox();
    await box.clear();
  }
}
