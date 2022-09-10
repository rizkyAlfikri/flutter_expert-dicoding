import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_show/domain/usecases/get_now_paling__tv_shows.dart';
import 'package:tv_show/domain/usecases/get_populart_tv_shows.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv_shows.dart';

part 'tv_show_list_event.dart';
part 'tv_show_list_state.dart';

class NowPlayingTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetNowPlayingTvShows _getNowPlayingTvShows;

  NowPlayingTvShowBloc(
    this._getNowPlayingTvShows,
  ) : super(TvShowListLoadingState()) {
    onFetchNowPlayingTvShows();
  }

  onFetchNowPlayingTvShows() {
    on<OnFetchNowPlayingTvShows>((event, emit) async {
      emit(TvShowListLoadingState());
      final result = await _getNowPlayingTvShows.execute();
      result.fold(
        (error) {
          emit(TvShowListErrorState(error.message));
        },
        (data) {
          emit(NowPlayingTvShowListState(data));
        },
      );
    });
  }
}

class PopularTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetPopularTvShows _getPopularTvShows;

  PopularTvShowBloc(
    this._getPopularTvShows,
  ) : super(TvShowListLoadingState()) {
    onFetchPopularTvShows();
  }

  onFetchPopularTvShows() {
    on<OnFetchPopularTvShows>((event, emit) async {
      emit(TvShowListLoadingState());
      final result = await _getPopularTvShows.execute();
      result.fold(
        (error) {
          emit(TvShowListErrorState(error.message));
        },
        (data) {
          emit(PolularTvShowListState(data));
        },
      );
    });
  }
}

class TopRatedTvShowBloc extends Bloc<TvShowListEvent, TvShowListState> {
  final GetTopRatedTvShows _getTopRatedTvShows;

  TopRatedTvShowBloc(
    this._getTopRatedTvShows,
  ) : super(TvShowListLoadingState()) {
    onFetchTopRatedTvShows();
  }

  onFetchTopRatedTvShows() {
    on<OnFetchTopRatedTvShows>((event, emit) async {
      emit(TvShowListLoadingState());
      final result = await _getTopRatedTvShows.execute();
      result.fold(
        (error) {
          emit(TvShowListErrorState(error.message));
        },
        (data) {
          emit(TopRatedTvShowListState(data));
        },
      );
    });
  }
}
