part of 'watchlist_tv_show_bloc.dart';

abstract class WatchlistTvShowState extends Equatable {
  const WatchlistTvShowState();

  @override
  List<Object> get props => [];
}

class WatchlistTvShowLoadingState extends WatchlistTvShowState {}

class WatchlistTvShowErrorState extends WatchlistTvShowState {
  final String message;

  const WatchlistTvShowErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvShowsSuccessState extends WatchlistTvShowState {
  final List<TvShow> tvShows;

  const WatchlistTvShowsSuccessState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}
