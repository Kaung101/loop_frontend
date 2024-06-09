import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
class AuthRepository {
  final String baseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
  final storage = const  FlutterSecureStorage();
  Future<String> login({required String email, required String password}) async {
    
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if(response.statusCode == 200){
      //store token
      // to save token in local storage
      await storage.write(key: 'jwtToken', value: jsonDecode(response.body)['token']);
    }else{
      return  'Wrong Password or Email';
      }

  return '';
  }
  

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body : jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    if(response.statusCode == 200){
      print("User created successfully");
    }else{
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['errorMessage'] ?? errorData);
    }
  
}
Future<void> logoutUser(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log out');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'jwt');
    if (token == null) return false;

    // Check token validity
    try {
      final isExpired = Jwt.isExpired(token);
      return !isExpired;
    } catch (e) {
      return false;
    }
  }
  //checkEmail
  Future<bool> checkExistEmail({required String email}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/checkEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
  
  Future<String?> getAuthToken() async {
    return await storage.read(key: 'jwtToken');
  }
  Future<Map<String, dynamic>?> fetchUserData() async {
    final authToken = await getAuthToken();
    if (authToken != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/me'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      if (response.statusCode == 200) {
          return jsonDecode(response.body);
        //return jsonDecode(response.body);
      }
    }
    return null;
  }

  // Future<void> followUser(String token, String followeeId) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/api/auth/follow'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({'followeeId': followeeId}),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to follow user');
  //   }
  // }

  // Future<void> unfollowUser(String token, String followeeId) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/api/auth/unfollow'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({'followeeId': followeeId}),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to unfollow user');
  //   }
  // }

  
}
