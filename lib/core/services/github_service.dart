import 'package:dio/dio.dart';

class GitHubService {
  final Dio dio;

  GitHubService(this.dio);

  Future<Map<String, dynamic>> fetchUser(String username) async {
    final response = await dio.get('https://api.github.com/users/$username');
    return response.data;
  }
}
