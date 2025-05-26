import 'package:dio/dio.dart';
import 'package:markopi/providers/Connection.dart';

Future<Response> sendToMail(String email) {
  final dio = Dio();

  return dio.post(
    Connection.buildUrl('/password/forgot'),
    data: {'email': email},
    options: Options(
      contentType: Headers.jsonContentType,
      headers: {
        Headers.contentTypeHeader: 'application/json',
        Headers.acceptHeader: 'application/json',
      },
    ),
  );
}
