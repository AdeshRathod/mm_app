import 'package:dio/dio.dart';

class Api {
  final Dio _dio;
  final String baseUrl;

  Api(this._dio, {this.baseUrl = "https://arclen-mm-backend.hf.space"});

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _dio.get('$baseUrl/api/v1/dashboard/stats');
    return response.data;
  }

  Future<List<dynamic>> getUsers() async {
    final response = await _dio.get('$baseUrl/api/v1/users/');
    return response.data;
  }
}
