import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  static const String baseUrl = 'https://api.github.com/users/';

  Future<Map<String, dynamic>> getUserStats(String username) async {
    try {
      print('Fetching GitHub data for $username');
      // Get user data
      final userResponse = await http.get(
        Uri.parse('$baseUrl$username'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      // Get repositories data
      final reposResponse = await http.get(
        Uri.parse('$baseUrl$username/repos'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (userResponse.statusCode == 200 && reposResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        final reposList = json.decode(reposResponse.body) as List;

        // Calculate total stars
        int totalStars = 0;
        for (var repo in reposList) {
          totalStars += (repo['stargazers_count'] as int? ?? 0);
        }

        print('User data: $userData');
        return {
          'followers': userData['followers'] ?? 0,
          'public_repos': userData['public_repos'] ?? 0,
          'stars': totalStars,
          'avatar_url': userData['avatar_url'] ?? '',
          'name': userData['name'] ?? username,
        };
      } else {
        throw Exception('Failed to load GitHub data');
      }
    } catch (e) {
      throw Exception('Error fetching GitHub data: $e');
    }
  }
}
