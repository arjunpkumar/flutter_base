import 'package:dio/dio.dart';
import 'package:thinkhub/src/core/constants.dart';
import 'package:thinkhub/src/core/exceptions.dart';
import 'package:thinkhub/src/domain/database/core/app_database.dart';

class UserService {
  Future<Map<String, dynamic>> fetchUser(String token) async {
    final response = await NetworkClient.dioInstance.get(
      APIEndpoints.userinfo,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw CustomException('Error Fetching User');
    }

    return response.data as Map<String, dynamic>;
  }
}

class UserMapper {
  User fromNetworkJson(Map<String, dynamic> json) {
    return User(
      id: json["sub"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      designation: json["designation"],
      email: json["email"],
    );
  }
}

bool getBool(String value) {
  return value.toLowerCase() == "true";
}
