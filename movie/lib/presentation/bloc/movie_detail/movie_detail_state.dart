part of 'movie_detail_bloc.dart';

abstract class MovieDetailBlocState extends Equatable {
  const MovieDetailBlocState();

  @override
  List<Object> get props => [];
}

class MovieDetailLoadingState extends MovieDetailBlocState {}

class MovieDetailErrorState extends MovieDetailBlocState {
  final String message;

  const MovieDetailErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailSuccessState extends MovieDetailBlocState {
  final MovieDetail movieDetail;
  final List<Movie> movieRecommendations;

  const MovieDetailSuccessState(
    this.movieDetail,
    this.movieRecommendations,
  );

  @override
  List<Object> get props => [
        movieDetail,
        movieRecommendations,
      ];
}

class MovieWatchlistStatusState extends MovieDetailBlocState {
  final bool isAdded;
  final String message;

  const MovieWatchlistStatusState(this.isAdded, this.message);

  @override
  List<Object> get props => [isAdded, message];
}
