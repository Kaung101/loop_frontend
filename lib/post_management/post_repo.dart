
import 'dart:convert';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
class PostRepository {
  final String baseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
  final storage = const  FlutterSecureStorage();

  Future<String> createPost({
    required String name, required String price, required String description
  }) async {
    final readKey = await storage.read(key: 'jwtToken');
    if(readKey == null) return 'User is not login!';
    final response = await http.post(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json', 'Authorization': "Bearer $readKey"},
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description
      }),
    );

    if (response.statusCode == 400) {
      final errorMessage = jsonDecode(response.body) as Map<String, dynamic>;
      
      return errorMessage["message"];
    }

    return '';
  }
}