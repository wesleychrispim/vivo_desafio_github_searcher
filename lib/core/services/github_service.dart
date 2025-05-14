import 'package:dio/dio.dart';

class GitHubService {
  final Dio dio;

  GitHubService(this.dio);

  Future<Map<String, dynamic>> fetchUser(String username) async {
    final response = await dio.get('https://api.github.com/users/$username');
    return response.data;
  }

  Future<List<Map<String, dynamic>>> fetchUserRepos(String username) async {
    final response = await dio.get('https://api.github.com/users/$username/repos');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<int> fetchCommitsCount(String owner, String repoName) async {
    final response = await dio.get('https://api.github.com/repos/$owner/$repoName/commits');
    if (response.statusCode == 200) {
      return (response.data as List).length;
    } else {
      return 0;
    }
  }
}
