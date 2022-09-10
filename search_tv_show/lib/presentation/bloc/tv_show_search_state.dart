part of 'tv_show_search_bloc.dart';

abstract class TvShowSearchState extends Equatable {
  const TvShowSearchState();

  @override
  List<Object> get props => [];
}

class TvShowSearchEmptyState extends TvShowSearchState {}

class TvShowSearchLoadingState extends TvShowSearchState {}

class TvShowSearchErrorState extends TvShowSearchState {
  final String message;

  const TvShowSearchErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class TvShowSearchSuccessState extends TvShowSearchState {
  final List<TvShow> results;

  const TvShowSearchSuccessState(this.results);

  @override
  List<Object> get props => [results];
}
