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

  Future<dynamic> registerUser(Map<String, dynamic> data) async {
    final response =
        await _dio.post('$baseUrl/api/v1/auth/register', data: data);
    return response.data;
  }

  Future<dynamic> loginUser(Map<String, dynamic> data) async {
    final response = await _dio.post('$baseUrl/api/v1/auth/login', data: data);
    return response.data;
  }

  Future<dynamic> getUser(String id) async {
    final response = await _dio.get('$baseUrl/api/v1/users/$id');
    return response.data;
  }

  Future<dynamic> updateUser(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('$baseUrl/api/v1/users/$id', data: data);
    return response.data;
  }

  Future<List<dynamic>> getSubscriptions() async {
    final response = await _dio.get('$baseUrl/api/v1/subscriptions/');
    return response.data;
  }

  Future<dynamic> createPaymentOrder(double amount) async {
    final response =
        await _dio.post('$baseUrl/api/v1/payments/create-order?amount=$amount');
    return response.data;
  }

  Future<dynamic> getPaymentConfig() async {
    final response = await _dio.get('$baseUrl/api/v1/payments/config');
    return response.data;
  }

  Future<dynamic> purchaseSubscription(String planId, String userId) async {
    final response =
        await _dio.post('$baseUrl/api/v1/subscriptions/purchase/$planId');
    // Note: userId is handled by token in backend usually, but our interceptor handles token?
    // Wait, the python code for purchase uses Depends(get_current_user_id), so token is needed.
    // Our dio client sends token? Yes, usually via interceptors if set.
    return response.data;
  }

  Future<List<dynamic>> getBanners() async {
    final response = await _dio.get('$baseUrl/api/v1/banners/');
    return response.data;
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final response = await _dio.get('$baseUrl/api/v1/users/$userId/stats');
    return response.data;
  }

  Future<Map<String, dynamic>> toggleShortlist(
      Map<String, dynamic> data) async {
    final response =
        await _dio.post('$baseUrl/api/v1/social/shortlist', data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> sendInterest(Map<String, dynamic> data) async {
    final response =
        await _dio.post('$baseUrl/api/v1/social/interest', data: data);
    return response.data;
  }

  Future<List<dynamic>> getShortlistedUsers(String userId) async {
    final response = await _dio.get('$baseUrl/api/v1/social/shortlist/$userId');
    return response.data;
  }

  Future<List<dynamic>> getReceivedInterests(String userId) async {
    final response =
        await _dio.get('$baseUrl/api/v1/social/interests/received/$userId');
    return response.data;
  }

  Future<Map<String, dynamic>> getSocialStatus(
      String userId, String targetId) async {
    final response = await _dio
        .get('$baseUrl/api/v1/social/status?userId=$userId&targetId=$targetId');
    return response.data;
  }
}
