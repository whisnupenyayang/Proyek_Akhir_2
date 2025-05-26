import 'dart:convert';
import './Connection.dart';
import 'package:get/get.dart';
  
class ForgotPasswordConnect extends GetConnect {

  Future<Response> resetPassword(String email, String otp, String password) {
    final body = jsonEncode({'email': email, 'otp': otp, 'password': password});

    return post(
      Connection.buildUrl('/password/reset'),
      body,
      contentType: 'application/json',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }
}
