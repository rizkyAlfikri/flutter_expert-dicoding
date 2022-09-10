part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieLoadingState extends WatchlistMovieState {}

class WatchlistMovieErrorState extends WatchlistMovieState {
  final String message;

  const WatchlistMovieErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesSuccessState extends WatchlistMovieState {
  final List<Movie> movies;

  const WatchlistMoviesSuccessState(this.movies);

  @override
  List<Object> get props => [movies];
}
