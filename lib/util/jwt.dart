import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

Future<String> getUserId() async {
  final token = await const FlutterSecureStorage().read(key: 'jwtToken');
  final tokenBody = Jwt.parseJwt(token!);

  return tokenBody['id'];
}

Future<String> getUsername() async {
  final token = await const FlutterSecureStorage().read(key: 'jwtToken');
  final tokenBody = Jwt.parseJwt(token!);

  return tokenBody['username'];
}

