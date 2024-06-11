import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class PostRepository {
  final String baseUrl = const String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://localhost:3000');
  final storage = const FlutterSecureStorage();

  Future<String> createPost({
    required bool status,
    required String name,
    required String price,
    required String description,
    required XFile beforePhoto,
    required XFile afterPhoto,
  }) async {
    final token = await storage.read(key: 'jwtToken');
    if (token == null) return 'User is not logged in!';
    
    final String? beforeMime = lookupMimeType(beforePhoto.path);
    final String? afterMime = lookupMimeType(afterPhoto.path);
    final beforeMimeType = MediaType.parse(beforeMime!);
    final afterMimeType = MediaType.parse(afterMime!);

    final formData = FormData.fromMap({
      'artist_post': status,
      'name': name,
      'price': price,
      'description': description,
      'before': await MultipartFile.fromFile(beforePhoto.path, contentType: beforeMimeType),
      'reference': await MultipartFile.fromFile(afterPhoto.path, contentType: afterMimeType),
    });

    final dio = Dio();

    try {
      final response = await dio.post(
        Uri.parse('$baseUrl/post').toString(),
        options: Options(
          headers: {'Authorization': "Bearer $token"},
        ),
        data: formData.clone(),
      );
    } catch (e) {
      print(e);
    }

    // final response = await http.post(
    //   Uri.parse('$baseUrl/post'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': "Bearer $readKey"
    //   },
    //   body: jsonEncode(
    //       {'name': name, 'price': price, 'description': description}),
    // );

    // if (response.statusCode == 400) {
    //   final errorMessage = jsonDecode(response.data) as Map<String, dynamic>;
    //   return errorMessage["message"];
    // }
    return '';
  }
}
