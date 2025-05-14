import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final Map<String, dynamic> user;
  final List<int> commitsCounts;
  final List<String> repositoryNames;

  const SearchSuccess(this.user, this.commitsCounts, this.repositoryNames);

  @override
  List<Object?> get props => [user, commitsCounts, repositoryNames];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object?> get props => [error];
}
