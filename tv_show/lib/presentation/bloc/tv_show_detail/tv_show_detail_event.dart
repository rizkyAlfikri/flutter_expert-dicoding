part of 'tv_show_detail_bloc.dart';

abstract class TvShowDetailEvent extends Equatable {
  const TvShowDetailEvent();

  @override
  List<Object> get props => [];
}

class OnFetchTvShowDetailEvent extends TvShowDetailEvent {
  final int tvShowId;

  const OnFetchTvShowDetailEvent(this.tvShowId);

  @override
  List<Object> get props => [tvShowId];
}

class OnAddTvShowWatchlistEvent extends TvShowDetailEvent {
  final TvShowDetail tvShowDetail;

  const OnAddTvShowWatchlistEvent(this.tvShowDetail);

  @override
  List<Object> get props => [tvShowDetail];
}

class OnRemoveTvShowFromWatchlistEvent extends TvShowDetailEvent {
  final TvShowDetail tvShowDetail;

  const OnRemoveTvShowFromWatchlistEvent(this.tvShowDetail);

  @override
  List<Object> get props => [tvShowDetail];
}

class OnInitTvShowWatchlistStatusEvent extends TvShowDetailEvent {
  final int tvShowId;

  const OnInitTvShowWatchlistStatusEvent(this.tvShowId);

  @override
  List<Object> get props => [tvShowId];
}
