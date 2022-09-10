part of 'tv_show_detail_bloc.dart';

abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object> get props => [];
}

class TvShowDetailLoadingState extends TvShowDetailState {}

class TvShowDetailErrorState extends TvShowDetailState {
  final String message;

  const TvShowDetailErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class TvShowDetailSuccessState extends TvShowDetailState {
  final TvShowDetail tvShowDetail;
  final List<TvShow> tvShowRecommendations;

  const TvShowDetailSuccessState(
    this.tvShowDetail,
    this.tvShowRecommendations,
  );

  @override
  List<Object> get props => [
        tvShowDetail,
        tvShowRecommendations,
      ];
}

class TvShowWatchlistStatusState extends TvShowDetailState {
  final bool isAdded;
  final String message;

  const TvShowWatchlistStatusState(this.isAdded, this.message);

  @override
  List<Object> get props => [isAdded, message];
}
