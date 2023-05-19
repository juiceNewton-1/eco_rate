import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> getDataFromUrl({required String url, String? apiKey}) async {
    try {
      final response = await http.get(Uri.parse('$url${apiKey ?? ''}'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json;
      }
    } catch (e) {
      log('ApiService || $e');
      rethrow;
    }
  }
}
