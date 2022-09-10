import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class NowPlayingMovieBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieBloc(
    this._getNowPlayingMovies,
  ) : super(MovieListLoadingState()) {
    onFetchNowPlayingMovies();
  }

  onFetchNowPlayingMovies() {
    on<OnFetchNowPlayingMovies>((event, emit) async {
      emit(MovieListLoadingState());
      final result = await _getNowPlayingMovies.execute();
      result.fold(
        (error) {
          emit(MovieListErrorState(error.message));
        },
        (data) {
          emit(NowPlayingMovieListState(data));
        },
      );
    });
  }
}

class PopularMovieBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(
    this._getPopularMovies,
  ) : super(MovieListLoadingState()) {
    onFetchPopularMovies();
  }

  onFetchPopularMovies() {
    on<OnFetchPopularMovies>((event, emit) async {
      emit(MovieListLoadingState());
      final result = await _getPopularMovies.execute();
      result.fold(
        (error) {
          emit(MovieListErrorState(error.message));
        },
        (data) {
          emit(PolularMovieListState(data));
        },
      );
    });
  }
}

class TopRatedMovieBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(
    this._getTopRatedMovies,
  ) : super(MovieListLoadingState()) {
    onFetchTopRatedMovies();
  }

  onFetchTopRatedMovies() {
    on<OnFetchTopRatedMovies>((event, emit) async {
      emit(MovieListLoadingState());
      final result = await _getTopRatedMovies.execute();
      result.fold(
        (error) {
          emit(MovieListErrorState(error.message));
        },
        (data) {
          emit(TopRatedMovieListState(data));
        },
      );
    });
  }
}
