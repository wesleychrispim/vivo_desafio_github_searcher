import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/github_service.dart';
import '../widgets/user_card.dart';
import '../widgets/user_repositories_chart.dart';
import '../../history/pages/history_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final GitHubService service = GitHubService(Dio());
  Map<String, dynamic>? _user;

  Future<void> _searchUser() async {
    final username = _controller.text.trim();
    if (username.isEmpty) return;

    try {
      final user = await service.fetchUser(username);
      setState(() {
        _user = user;
      });

      // Salvando no histórico
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList('search_history') ?? [];
      if (!history.contains(username)) {
        history.add(username);
        await prefs.setStringList('search_history', history);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado')),
      );
    }
  }

  Future<void> _openHistory() async {
    final username = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );
    if (username != null) {
      _controller.text = username;
      await _searchUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Usuário GitHub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _openHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Digite o username...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchUser(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchUser,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _user == null
                  ? const Center(child: Text('Nenhuma busca realizada ainda'))
                  : ListView(
                children: [
                  UserCard(user: _user!),
                  const SizedBox(height: 24),
                  UserRepositoriesChart(
                    repositoryCounts: [10, 8, 5, 12, 7], // Simulado
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
