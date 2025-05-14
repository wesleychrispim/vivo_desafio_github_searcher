class UserModel {
  final String username;
  final String name;
  final String bio;
  final String location;
  final int followers;
  final int publicRepos;

  UserModel({
    required this.username,
    required this.name,
    required this.bio,
    required this.location,
    required this.followers,
    required this.publicRepos,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['login'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      location: map['location'] ?? '',
      followers: map['followers'] ?? 0,
      publicRepos: map['public_repos'] ?? 0,
    );
  }
}
