part of 'tv_show_search_bloc.dart';

abstract class TvShowSearchEvent extends Equatable {
  const TvShowSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChangedEvent extends TvShowSearchEvent {
  final String query;

  const OnQueryChangedEvent(this.query);

  @override
  List<Object> get props => [query];
}
