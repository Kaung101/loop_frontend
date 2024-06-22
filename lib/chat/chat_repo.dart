import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loop/util/env.dart';
import 'package:tuple/tuple.dart';

class ChatRepository {
  final String baseUrl = AppEnv.getBaseUrl();
  final storage = const FlutterSecureStorage();

  Future<List<Tuple2<String, String>>> fetchContacts() async {
    final token = await storage.read(key: 'jwtToken');
    if (token == null) throw Exception('User not logged in');

    try {
      final response = await http.get(Uri.parse('$baseUrl/chat/people'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final Map parsed = json.decode(response.body);
        final List parsedList = parsed['data'];
        List<Tuple2<String, String>> list = parsedList
            .map<Tuple2<String, String>>(
                (val) => Tuple2(val['id'], val['username']))
            .toList();

        return list;
      } else {
        throw Exception('Encountered an error while fetching contacts');
      }
    } catch (e) {
      throw Exception('Could not fetch contacts');
    }
  }
}
