import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivo_desafio_github_searcher/core/services/github_service.dart';
import 'package:vivo_desafio_github_searcher/modules/search/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final GitHubService service;

  SearchCubit(this.service) : super(SearchInitial());

  Future<void> fetchUser(String username) async {
    if (username.isEmpty) return;

    emit(SearchLoading());
    try {
      final user = await service.fetchUser(username);
      emit(SearchSuccess(user));
    } catch (_) {
      emit(SearchFailure('Usuário não encontrado'));
    }
  }
}
