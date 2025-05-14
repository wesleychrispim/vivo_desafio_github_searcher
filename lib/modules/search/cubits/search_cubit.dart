import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivo_desafio_github_searcher/core/services/github_service.dart';
import 'package:vivo_desafio_github_searcher/modules/search/cubits/search_state.dart';
import 'package:vivo_desafio_github_searcher/modules/search/models/search_filter.dart';

class SearchCubit extends Cubit<SearchState> {
  final GitHubService service;

  SearchCubit(this.service) : super(SearchInitial());

  Future<void> fetchUser(String username, {SearchFilter? filter}) async {
    if (username.isEmpty) return;

    emit(SearchLoading());
    try {
      final user = await service.fetchUser(username);

      if (filter != null) {
        if (filter.location != null &&
            (user['location']?.toLowerCase() ?? '') != filter.location!.toLowerCase()) {
          emit(const SearchFailure('Localização não confere.'));
          return;
        }
        if (filter.minFollowers != null &&
            (user['followers'] ?? 0) < filter.minFollowers!) {
          emit(const SearchFailure('Número de seguidores insuficiente.'));
          return;
        }
        if (filter.minRepositories != null &&
            (user['public_repos'] ?? 0) < filter.minRepositories!) {
          emit(const SearchFailure('Número de repositórios insuficiente.'));
          return;
        }
        if (filter.language != null) {
          final repos = await service.fetchUserRepos(username);
          final hasLanguage = repos.any((repo) =>
          (repo['language']?.toLowerCase() ?? '') == filter.language!.toLowerCase());
          if (!hasLanguage) {
            emit(const SearchFailure('Linguagem de programação não encontrada.'));
            return;
          }
        }
      }

      final repos = await service.fetchUserRepos(username);
      // ➔ NÃO usamos mais .take(5), agora pegamos todos!

      List<int> commitsCounts = [];
      List<String> repositoryNames = [];

      for (var repo in repos) {
        final repoName = repo['name'];
        if (repoName != null) {
          final count = await service.fetchCommitsCount(username, repoName);
          commitsCounts.add(count);
          repositoryNames.add(repoName);
        }
      }

      emit(SearchSuccess(user, commitsCounts, repositoryNames));
    } catch (_) {
      emit(const SearchFailure('Usuário não encontrado'));
    }
  }
}
