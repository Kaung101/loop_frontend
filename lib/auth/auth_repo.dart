import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:loop/other_profile/other_profile.dart';
import 'package:loop/user_management/view_profile.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' show MediaType;
class AuthRepository {
  final String baseUrl = const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000');
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
    if(response.body != 'null'){
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

/* 
  //edit profile
  Future<bool> editProfile({required String firstName, required String lastName, required String username, required String email}) async{
    final response = await http.put(
      Uri.parse('$baseUrl/api/auth/editProfile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,}),
    );
    if(response.body == 'true'){
      return true;
  }  
  return false;
  } */

  // Future<String?> uploadProfilePhoto(Uint8List imageBytes) async {
  //   final uploadUrl = '$baseUrl/api/auth/me'; // Replace with your actual API endpoint
  //   try {
  //     final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
  //       ..files.add(
  //         http.MultipartFile.fromBytes(
  //           'file',
  //           imageBytes,
  //           filename: 'profile_photo.png',
  //           contentType: MediaType('image', 'png'),
  //         ),
  //       );

  //     final response = await request.send();

  //     if (response.statusCode == 200) {
  //       final responseBody = await http.Response.fromStream(response);
  //       final responseData = json.decode(responseBody.body);
  //       return responseData['url'];
  //     } else {
  //       print('Failed to upload profile photo. Status code: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Upload error: $e');
  //     return null;
  //   }
  // }
Future<String?> uploadProfilePhoto( {required XFile profilePhoto}) async {
    final token = await storage.read(key: 'jwtToken');
    if(token == null) return "User is not loggined";
    final String? photomime = lookupMimeType(profilePhoto.path);
    final photomimeType = MediaType.parse(photomime!);
    /* final formData = FormData.fromMap(
      {
        'profile_photo': await MultipartFile.fromFile(profilePhoto.path, contentType: photomimeType),
      }
    ); */
    final dio = Dio();

    try{
          final bytes = await profilePhoto.readAsBytes();
          String? base64Image = base64Encode(bytes);
          //print(base64Image);
      final response = await dio.post(
        Uri.parse('$baseUrl/api/auth/uploadProfilePhoto').toString(),
        options: Options(
          headers: {'Authorization' : "Bearer $token"},
        ),
        data: jsonEncode(
          {
            'profile_photo': base64Image,
          }
        ),
      );
    }
    catch(e){
      print(e);
    }
  }


  /* Future<List<Map<String, dynamic>>> fetchUsers(String baseUrl, {String? searchQuery}) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/auth/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      
      // Filter users based on search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        data = data.where((user) => user['username'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }
      
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch users');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
} */

Future<List<Map<String, dynamic>>> fetchUsers(String? searchQuery) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/auth/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      
      // Filter users based on search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        data = data.where((user) => user['username'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
      }
      
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch users');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchPosts(String? searchQuery) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/show/allPost'));
     
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Filter posts based on search query
        if (searchQuery != null && searchQuery.isNotEmpty) {
          data = data.where((post) => post['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                                      post['description'].toLowerCase().contains(searchQuery.toLowerCase())).toList();
        }
        
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

 Future<String> changePassword(String email, String currentPassword, String newPassword) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/api/auth/changePassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');


    if (response.statusCode == 200) {
      // Password updated successfully
      return 'true';
    } else if (response.statusCode == 400) {
      // Handle specific error cases
      final error = jsonDecode(response.body)['error'];
      return error;
    } else {
      // Handle other status codes
      return 'Failed to update password. Status Code: ${response.statusCode}';
    }
  } catch (e) {
    print('Error changing password: $e');
    return 'Error changing password';
  }
 }
 //new condition of own profile all post
 //get other profile post
  Future<List<dynamic>> ownProfilePost({required String userId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/owner/ownerProfilePost/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      return [];
    }
  }


  //update show_post status
  //update password
  Future<bool> show_postStatus({required String postId, required bool status}) async{
   
    final response = await http.put(
      Uri.parse('$baseUrl/show/updatePost'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': postId,
        'dropdownValue': status,
      }),
    );
    if(response.body == 'true'){
      return true;
  }  
  return false;
  }

  //delete post
  Future<void> deletePost(String postId) async {
    try{
      final token = await storage.read(key: 'jwtToken');
      final response = await http.delete(
        Uri.parse('$baseUrl/post?post_id=$postId'),
        headers:{
          'Authorization': 'Bearer $token',
      },
        );
        if(response.statusCode == 204){
          print('Post deleted successfully');
    } else {
      print('Failed to delete post. Status code: ${response.statusCode}');
      throw Exception('Failed to delete post');
    }
    }catch(e){
      print('Error deleting post: $e');
      throw Exception('Error deleting post');
    }
    
  }

}


/* Future<bool> changePassword( String currentPassword, String newPassword) async {
  final authToken = await getAuthToken();
  if (authToken != null){
     final response = await http.put(
        Uri.parse('$baseUrl/api/auth/users'),
        headers: {'Authorization': 'Bearer $authToken'},
        body: jsonEncode(
          {
            'currentPassword': currentPassword,
            'newPassword': newPassword,
          }
        )
      );
      if (response.statusCode == 200) {
          return jsonDecode(response.body);
        //return jsonDecode(response.body);
      }
  }
        return false;
} */

    /* final response = await http.put(

      Uri.parse('$baseUrl/api/auth/users'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    ); */

    /* if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    } */
  
 //}}