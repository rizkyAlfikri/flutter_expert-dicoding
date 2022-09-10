part of 'tv_show_list_bloc.dart';

abstract class TvShowListState extends Equatable {
  const TvShowListState();

  @override
  List<Object> get props => [];
}

class TvShowListLoadingState extends TvShowListState {}

class TvShowListErrorState extends TvShowListState {
  final String message;

  const TvShowListErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PolularTvShowListState extends TvShowListState {
  final List<TvShow> tvShows;

  const PolularTvShowListState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class NowPlayingTvShowListState extends TvShowListState {
  final List<TvShow> tvShows;

  const NowPlayingTvShowListState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class TopRatedTvShowListState extends TvShowListState {
  final List<TvShow> tvShows;

  const TopRatedTvShowListState(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}
