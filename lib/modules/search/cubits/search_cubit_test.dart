import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vivo_desafio_github_searcher/core/services/github_service.dart';
import 'package:vivo_desafio_github_searcher/modules/search/cubits/search_cubit.dart';
import 'package:vivo_desafio_github_searcher/modules/search/cubits/search_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGitHubService extends Mock implements GitHubService {}

void main() {
  late MockGitHubService mockService;
  late SearchCubit searchCubit;

  setUp(() {
    mockService = MockGitHubService();
    searchCubit = SearchCubit(mockService);
  });

  tearDown(() {
    searchCubit.close();
  });

  group('SearchCubit', () {
    const username = 'octocat';
    final mockUser = {
      'login': 'octocat',
      'name': 'The Octocat',
      'bio': 'GitHub mascot',
      'location': 'San Francisco',
      'followers': 100,
      'public_repos': 5,
    };

    blocTest<SearchCubit, SearchState>(
      'Emite [Loading, Success] ao buscar usuário com sucesso',
      build: () {
        when(() => mockService.fetchUser(username))
            .thenAnswer((_) async => mockUser);
        when(() => mockService.fetchUserRepos(username))
            .thenAnswer((_) async => [
          {'name': 'repo1'},
          {'name': 'repo2'},
          {'name': 'repo3'},
          {'name': 'repo4'},
          {'name': 'repo5'},
        ]);
        when(() => mockService.fetchCommitsCount(username, any()))
            .thenAnswer((_) async => 5);
        return searchCubit;
      },
      act: (cubit) => cubit.fetchUser(username),
      expect: () => [
        SearchLoading(),
        isA<SearchSuccess>(),
      ],
    );

    blocTest<SearchCubit, SearchState>(
      'Emite [Loading, Failure] ao falhar na busca do usuário',
      build: () {
        when(() => mockService.fetchUser(username))
            .thenThrow(Exception('Erro'));
        return searchCubit;
      },
      act: (cubit) => cubit.fetchUser(username),
      expect: () => [
        SearchLoading(),
        isA<SearchFailure>(),
      ],
    );
  });
}
