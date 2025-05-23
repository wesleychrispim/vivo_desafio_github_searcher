import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/github_service.dart';
import '../../history/pages/history_page.dart';
import '../cubits/search_cubit.dart';
import '../cubits/search_state.dart';
import '../models/search_filter.dart';
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
  final _locationController = TextEditingController();
  final _followersController = TextEditingController();
  final _reposController = TextEditingController();
  final _languageController = TextEditingController();

  Future<void> _openHistory() async {
    final username = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const HistoryPage()),
    );
    if (username != null) {
      _controller.text = username;
      _searchUser();
    }
  }

  void _searchUser() {
    final username = _controller.text.trim();
    if (username.isNotEmpty) {
      final filter = SearchFilter(
        location: _locationController.text.isEmpty ? null : _locationController.text,
        minFollowers: _followersController.text.isEmpty ? null : int.tryParse(_followersController.text),
        minRepositories: _reposController.text.isEmpty ? null : int.tryParse(_reposController.text),
        language: _languageController.text.isEmpty ? null : _languageController.text,
      );
      context.read<SearchCubit>().fetchUser(username, filter: filter);
    }
  }

  List<Widget> buildCharts(SearchSuccess state) {
    List<Widget> charts = [];

    for (int i = 0; i < state.repositoryNames.length; i += 5) {
      final namesSlice = state.repositoryNames.skip(i).take(5).toList();
      final countsSlice = state.commitsCounts.skip(i).take(5).toList();

      charts.add(
        Column(
          children: [
            UserRepositoriesChart(
              repositoryCounts: countsSlice,
              repositoryNames: namesSlice,
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return charts;
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
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Filtro: Localização (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _followersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Filtro: Mínimo de Seguidores (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reposController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Filtro: Mínimo de Repositórios (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _languageController,
              decoration: const InputDecoration(
                labelText: 'Filtro: Linguagem de Programação (opcional)',
                border: OutlineInputBorder(),
              ),
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
                        ...buildCharts(state),
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
