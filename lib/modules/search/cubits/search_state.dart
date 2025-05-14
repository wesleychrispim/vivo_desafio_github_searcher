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
  final List<int> commitsCounts; // Novo

  const SearchSuccess(this.user, this.commitsCounts);

  @override
  List<Object?> get props => [user, commitsCounts];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object?> get props => [error];
}
