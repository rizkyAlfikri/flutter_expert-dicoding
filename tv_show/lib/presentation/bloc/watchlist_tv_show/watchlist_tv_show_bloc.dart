import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_show/domain/usecases/get_watchlist_tv_shows.dart';

part 'watchlist_tv_show_event.dart';
part 'watchlist_tv_show_state.dart';

class WatchlistTvShowBloc
    extends Bloc<WatchlistTvShowEvent, WatchlistTvShowState> {
  final GetWatchlistTvShows _getWatchlistTvShows;
  WatchlistTvShowBloc(this._getWatchlistTvShows)
      : super(WatchlistTvShowLoadingState()) {
    onFetchWatchlistTvShows();
  }

  void onFetchWatchlistTvShows() {
    on<OnFetchWatchlistTvShowsEvent>(
      (event, emit) async {
        final result = await _getWatchlistTvShows.execute();

        result.fold((error) {
          emit(WatchlistTvShowErrorState(error.message));
        }, (data) {
          emit(WatchlistTvShowsSuccessState(data));
        });
      },
    );
  }
}
