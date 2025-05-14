import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user['name'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user['bio'] != null) Text('Bio: ${user['bio']}'),
            if (user['location'] != null) Text('Location: ${user['location']}'),
            Text('Followers: ${user['followers']}'),
            Text('Repositories: ${user['public_repos']}'),
          ],
        ),
      ),
    );
  }
}
