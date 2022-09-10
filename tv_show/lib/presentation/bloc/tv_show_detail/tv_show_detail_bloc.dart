import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_show/domain/usecases/get_tv_show_detail.dart';
import 'package:tv_show/domain/usecases/get_tv_show_recomendations.dart';
import 'package:tv_show/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv_show/domain/usecases/remove_tv_watchlist.dart';
import 'package:tv_show/domain/usecases/save_tv_watchlist.dart';

part 'tv_show_detail_event.dart';
part 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final GetTvShowDetail _getTvShowDetail;
  final GetTvShowRecomendations _getTvShowRecommendations;

  TvShowDetailBloc(this._getTvShowDetail, this._getTvShowRecommendations)
      : super(TvShowDetailLoadingState()) {
    onFetchTvShowDetail();
  }

  void onFetchTvShowDetail() {
    on<OnFetchTvShowDetailEvent>(((event, emit) async {
      emit(TvShowDetailLoadingState());
      final tvShowId = event.tvShowId;
      final detailResult = await _getTvShowDetail.execute(tvShowId);
      final recommendedResult =
          await _getTvShowRecommendations.execute(tvShowId);

      detailResult.fold((error) {
        emit(TvShowDetailErrorState(error.message));
      }, (data) {
        final tvShowDetail = data;
        recommendedResult.fold((error) {
          emit(TvShowDetailErrorState(error.message));
        }, (data) {
          final tvShowRecommendations = data;
          emit(TvShowDetailSuccessState(
            tvShowDetail,
            tvShowRecommendations,
          ));
        });
      });
    }));
  }
}

class TvShowDetailWatchlistBloc
    extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  final GetTvWatchListStatus _getWatchListStatus;
  final SaveTvWatchlist _saveWatchlist;
  final RemoveTvWatchlist _removeWatchlist;

  TvShowDetailWatchlistBloc(
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(TvShowDetailLoadingState()) {
    onAddTvShowWatchList();
    onRemoveTvShowWathclist();
    onInitTvShowWatchList();
  }

  void onAddTvShowWatchList() {
    on<OnAddTvShowWatchlistEvent>((event, emit) async {
      final tvShowDetail = event.tvShowDetail;

      final result = await _saveWatchlist.execute(tvShowDetail);
      final isAdded = await updateTvShowWatchlistStatus(tvShowDetail.id);
      result.fold((error) {
        emit(TvShowWatchlistStatusState(isAdded, error.message));
      }, (data) {
        emit(TvShowWatchlistStatusState(isAdded, data));
      });
    });
  }

  void onRemoveTvShowWathclist() {
    on<OnRemoveTvShowFromWatchlistEvent>((event, emit) async {
      final tvShowDetail = event.tvShowDetail;

      final result = await _removeWatchlist.execute(tvShowDetail);
      final isAdded = await updateTvShowWatchlistStatus(tvShowDetail.id);
      result.fold((error) {
        emit(TvShowWatchlistStatusState(isAdded, error.message));
      }, (data) {
        emit(TvShowWatchlistStatusState(isAdded, data));
      });
    });
  }

  void onInitTvShowWatchList() {
    on<OnInitTvShowWatchlistStatusEvent>((event, emit) async {
      final tvShowId = event.tvShowId;
      final isAdded = await updateTvShowWatchlistStatus(tvShowId);
      emit(TvShowWatchlistStatusState(isAdded, ''));
    });
  }

  Future<bool> updateTvShowWatchlistStatus(int tvShowId) async {
    final result = await _getWatchListStatus.execute(tvShowId);
    return result;
  }
}
