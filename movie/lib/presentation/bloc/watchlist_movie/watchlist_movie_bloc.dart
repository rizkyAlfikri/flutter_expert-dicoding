import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;
  WatchlistMovieBloc(this._getWatchlistMovies)
      : super(WatchlistMovieLoadingState()) {
    onFetchWatchlistMovies();
  }

  void onFetchWatchlistMovies() {
    on<OnFetchWatchlistMoviesEvent>(
      (event, emit) async {
        final result = await _getWatchlistMovies.execute();

        result.fold((error) {
          emit(WatchlistMovieErrorState(error.message));
        }, (data) {
          emit(WatchlistMoviesSuccessState(data));
        });
      },
    );
  }
}
