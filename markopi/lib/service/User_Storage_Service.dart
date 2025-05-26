import 'package:hive/hive.dart';
import './User_Storage.dart';

class UserStorage {
  static const String _boxName = 'user';
  late Box<UserModel> _box;

  Future<Box<UserModel>> openBox() async {
    _box = await Hive.openBox<UserModel>('user');
    return _box;
  }

  Future<void> saveUser(UserModel user) async {
    await _box.put('user', user);
  }

  UserModel? getUser() {
    return _box.get('user');
  }

  Future<void> deleteUser() async {
    await _box.delete('user');
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
