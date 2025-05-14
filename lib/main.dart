import 'package:flutter/material.dart';
import '../modules/search/pages/search_page.dart';

void main() {
  runApp(const GitHubUserSearcherApp());
}

class GitHubUserSearcherApp extends StatelessWidget {
  const GitHubUserSearcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub User Searcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SearchPage(),
    );
  }
}
