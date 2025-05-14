import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/github_service.dart';
import '../../history/pages/history_page.dart';
import '../cubits/search_cubit.dart';
import '../cubits/search_state.dart';
import '../widgets/user_card.dart';
import '../widgets/user_repositories_chart.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(GitHubService(Dio())),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();

  Future<void> _openHistory() async {
    final username = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );
    if (username != null) {
      _controller.text = username;
      context.read<SearchCubit>().fetchUser(username);
    }
  }

  void _searchUser() {
    final username = _controller.text.trim();
    if (username.isNotEmpty) {
      context.read<SearchCubit>().fetchUser(username);
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
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(child: Text('Nenhuma busca realizada ainda'));
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchSuccess) {
                    _saveSearchToHistory(state.user['login']);
                    return ListView(
                      children: [
                        UserCard(user: state.user),
                        const SizedBox(height: 24),
                        UserRepositoriesChart(
                          repositoryCounts: [10, 8, 5, 12, 7], // Simulado
                        ),
                      ],
                    );
                  } else if (state is SearchFailure) {
                    return Center(child: Text(state.error));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSearchToHistory(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_history') ?? [];
    if (!history.contains(username)) {
      history.add(username);
      await prefs.setStringList('search_history', history);
    }
  }
}
