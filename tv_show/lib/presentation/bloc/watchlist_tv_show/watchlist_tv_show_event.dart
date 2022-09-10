part of 'watchlist_tv_show_bloc.dart';

abstract class WatchlistTvShowEvent extends Equatable {
  const WatchlistTvShowEvent();

  @override
  List<Object> get props => [];
}

class OnFetchWatchlistTvShowsEvent extends WatchlistTvShowEvent {
  const OnFetchWatchlistTvShowsEvent();
}
