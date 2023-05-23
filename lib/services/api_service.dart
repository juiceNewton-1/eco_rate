import 'dart:developer';
import 'package:dio/dio.dart' as dio;

class ApiService {
  static const instance = ApiService._();
  const ApiService._();
  Future<dynamic> getDataFromUrl({required String url, String? apiKey}) async {
    try {
      // final response = await http.get(Uri.parse('$url${apiKey ?? ''}'));

      final response = await dio.Dio().getUri(Uri.parse('$url${apiKey ?? ''}'));
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('ApiService || $e');
      rethrow;
    }
  }
}
