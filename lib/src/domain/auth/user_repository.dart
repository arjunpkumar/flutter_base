import 'dart:async';

import 'package:thinkhub/src/core/exceptions.dart';
import 'package:thinkhub/src/domain/auth/user_service.dart';
import 'package:thinkhub/src/domain/database/core/app_database.dart';
import 'package:thinkhub/src/domain/database/user_dao.dart';

class UserRepository {
  final UserDao userDao;
  final UserService networkProvider;
  final UserMapper userMapper;

  static UserRepository? instance;

  UserRepository({
    required this.userDao,
    required this.networkProvider,
    required this.userMapper,
  });

  Future<User> getUser(String? token) async {
    if (token == null || token.isEmpty) {
      throw CustomException('INVALID TOKEN');
    }
    final networkJson = await networkProvider.fetchUser(token);
    final user = userMapper.fromNetworkJson(networkJson);
    return user;
  }

  Future<User?> userById(String userId) {
    return userDao.userById(userId);
  }

  Future<void> saveUser(User user) async {
    await userDao.saveUser(user);
  }

  Future<User?> getActiveUser() async {
    return userDao.getActiveUser();
  }

  Stream<User> watchGetActiveUser() {
    return userDao.watchGetActiveUser();
  }

  Future<void> deleteUsers() async {
    return userDao.deleteUsers();
  }
}
