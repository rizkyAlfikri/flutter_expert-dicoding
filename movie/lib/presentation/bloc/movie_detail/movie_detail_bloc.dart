import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailBlocEvent, MovieDetailBlocState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;

  MovieDetailBloc(
    this._getMovieDetail,
    this._getMovieRecommendations,
  ) : super(MovieDetailLoadingState()) {
    onFetchMovieDetail();
  }

  void onFetchMovieDetail() {
    on<OnFetchMovieDetailEvent>(((event, emit) async {
      emit(MovieDetailLoadingState());
      final movieId = event.movieId;
      final detailResult = await _getMovieDetail.execute(movieId);
      final recommendedResult = await _getMovieRecommendations.execute(movieId);

      detailResult.fold((error) {
        emit(MovieDetailErrorState(error.message));
      }, (data) {
        final movieDetail = data;
        recommendedResult.fold((error) {
          emit(MovieDetailErrorState(error.message));
        }, (data) {
          final movieRecommendations = data;
          emit(MovieDetailSuccessState(
            movieDetail,
            movieRecommendations,
          ));
        });
      });
    }));
  }
}

class MovieDetailWatchlistBloc
    extends Bloc<MovieDetailBlocEvent, MovieDetailBlocState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  MovieDetailWatchlistBloc(
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(MovieDetailLoadingState()) {
    onAddMovieWatchList();
    onRemoveMovieWathclist();
    onInitMovieWatchList();
  }

  void onAddMovieWatchList() {
    on<OnAddMovieWatchlistEvent>((event, emit) async {
      final movieDetail = event.movieDetail;

      final result = await _saveWatchlist.execute(movieDetail);
      final isAdded = await updateMovieWatchlistStatus(movieDetail.id);

      result.fold((error) {
        emit(MovieWatchlistStatusState(isAdded, error.message));
      }, (data) {
        AnalyticTracker.sendMovieFavoriteAnalyticsEvent(movieDetail, true);
        emit(MovieWatchlistStatusState(isAdded, data));
      });
    });
  }

  void onRemoveMovieWathclist() {
    on<OnRemoveMovieFromWatchlistEvent>((event, emit) async {
      final movieDetail = event.movieDetail;

      final result = await _removeWatchlist.execute(movieDetail);
      final isAdded = await updateMovieWatchlistStatus(movieDetail.id);
      result.fold((error) {
        emit(MovieWatchlistStatusState(isAdded, error.message));
      }, (data) {
        AnalyticTracker.sendMovieFavoriteAnalyticsEvent(movieDetail, false);
        emit(MovieWatchlistStatusState(isAdded, data));
      });
    });
  }

  void onInitMovieWatchList() {
    on<OnInitMovieWatchlistStatusEvent>((event, emit) async {
      final movieId = event.movieId;
      final isAdded = await updateMovieWatchlistStatus(movieId);
      emit(MovieWatchlistStatusState(isAdded, ''));
    });
  }

  Future<bool> updateMovieWatchlistStatus(int movieId) {
    final result = _getWatchListStatus.execute(movieId);
    return result;
  }
}
