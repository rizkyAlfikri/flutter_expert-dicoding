part of 'movie_search_bloc.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

class MovieSearchEmptyState extends MovieSearchState {}

class MovieSearchLoadingState extends MovieSearchState {}

class MovieSearchErrorState extends MovieSearchState {
  final String message;

  const MovieSearchErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class MovieSearchSuccessState extends MovieSearchState {
  final List<Movie> results;

  const MovieSearchSuccessState(this.results);

  @override
  List<Object> get props => [results];
}
