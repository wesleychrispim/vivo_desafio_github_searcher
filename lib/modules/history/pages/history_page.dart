import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() {
      _history = history.reversed.toList();
    });
  }

  Future<void> _searchAgain(String username) async {
    Navigator.pop(context, username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Buscas')),
      body: _history.isEmpty
          ? const Center(child: Text('Nenhuma busca ainda'))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final username = _history[index];
          return ListTile(
            title: Text(username),
            trailing: const Icon(Icons.search),
            onTap: () => _searchAgain(username),
          );
        },
      ),
    );
  }
}
