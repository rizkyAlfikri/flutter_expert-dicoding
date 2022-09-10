part of 'movie_detail_bloc.dart';

abstract class MovieDetailBlocEvent extends Equatable {
  const MovieDetailBlocEvent();

  @override
  List<Object> get props => [];
}

class OnFetchMovieDetailEvent extends MovieDetailBlocEvent {
  final int movieId;

  const OnFetchMovieDetailEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class OnAddMovieWatchlistEvent extends MovieDetailBlocEvent {
  final MovieDetail movieDetail;

  const OnAddMovieWatchlistEvent(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class OnRemoveMovieFromWatchlistEvent extends MovieDetailBlocEvent {
  final MovieDetail movieDetail;

  const OnRemoveMovieFromWatchlistEvent(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class OnInitMovieWatchlistStatusEvent extends MovieDetailBlocEvent {
  final int movieId;

  const OnInitMovieWatchlistStatusEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
