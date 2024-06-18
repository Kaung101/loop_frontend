import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loop/other_profile/other_profile.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
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
    if(response.body == 'true'){
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
        print(response.body);
          return jsonDecode(response.body);
        //return jsonDecode(response.body);
      }
    }
    return null;
  }
  //update password
  Future<bool> updatePassoword({required String email, required String password}) async{
    final response = await http.put(
      Uri.parse('$baseUrl/api/auth/updatePassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if(response.body == 'true'){
      return true;
  }  
  return false;
  }

  //get all post data
  Future<List<dynamic>> fetchAllPost() async {
    final response = await http.get(
      Uri.parse('$baseUrl/show/allPost'),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      print(response.body);
      return jsonDecode(response.body);
    }else{
      return [];
    }
  }
 //get all post data
  Future<List<dynamic>> fetchOwnerPost() async {
    final response = await http.get(
      Uri.parse('$baseUrl/owner/allPost'),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      return [];
    }
  }
  //get other profile post
  Future<List<dynamic>> otherProfilePost({required String userId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/show/otherProfilePost/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      return [];
    }
  }

  //fetch other profile user data
  Future<Map<String, dynamic>?> fetchOtherProfileData({required String userId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/getUserById/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      return null;
    }
  }

  //edit profile
  Future<bool> editProfile({required String firstName, required String lastName, required String username, required String email, 
}) async{
    final response = await http.put(
      Uri.parse('$baseUrl/api/auth/editProfile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,}),
    );
    print(response.body);
    if(response.body == 'true'){
      
      return true;
  }  
  return false;
  }

  //edit proifle image with header barer token

  Future<bool> editProfileImage({required XFile image, required String userId}) async{
    final bytes = image.readAsBytes();
    final imageStr = base64Encode(await bytes);
    final String? imageMime = lookupMimeType(image.path);
    final imageMimeType = MediaType.parse(imageMime!);

    print(imageStr);
    final response = await http.put(
      Uri.parse('$baseUrl/api/auth/editProfileImage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'image': imageStr,
        'mimeType': imageMimeType.toString(),
      }),
    );
    final res = response.body;
    if(response.body != 'null'){
      return true;
    }
    return false;
  }


}
