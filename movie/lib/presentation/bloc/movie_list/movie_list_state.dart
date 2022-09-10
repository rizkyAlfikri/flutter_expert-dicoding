part of 'movie_list_bloc.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListLoadingState extends MovieListState {}

class MovieListErrorState extends MovieListState {
  final String message;

  const MovieListErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PolularMovieListState extends MovieListState {
  final List<Movie> movies;

  const PolularMovieListState(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMovieListState extends MovieListState {
  final List<Movie> movies;

  const NowPlayingMovieListState(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMovieListState extends MovieListState {
  final List<Movie> movies;

  const TopRatedMovieListState(this.movies);

  @override
  List<Object> get props => [movies];
}
