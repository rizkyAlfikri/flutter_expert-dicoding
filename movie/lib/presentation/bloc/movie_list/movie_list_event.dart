part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class OnFetchNowPlayingMovies extends MovieListEvent {
  const OnFetchNowPlayingMovies();
}

class OnFetchPopularMovies extends MovieListEvent {
  const OnFetchPopularMovies();
}

class OnFetchTopRatedMovies extends MovieListEvent {
  const OnFetchTopRatedMovies();
}

class OnLoadingMovieList extends MovieListEvent {
  const OnLoadingMovieList();
}
