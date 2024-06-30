import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class NotificationRepository {
  final String baseUrl = const String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://54.254.8.87');
  final storage = const FlutterSecureStorage();
  Future<String> updateFcmToken({
    required String fcmToken,
}) async{
    final token = await storage.read(key: 'jwtToken');
    if (token == null) return 'User is not logged in!';
    if  (fcmToken.isEmpty) return 'Not connected with firebase!';

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/auth/update_fcm'),
          headers: {'Authorization': "Bearer $token"},
        body: {
          'fcm_token': fcmToken,
        },
      );
      if(response.statusCode == 200){
      } else {
        return 'Could  not update fcm-token!';
      }
    } catch (e) {
      print(e);
    }

    return '';
  }

}