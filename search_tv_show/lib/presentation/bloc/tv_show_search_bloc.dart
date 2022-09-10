import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/transformers.dart';
import 'package:search_tv_show/domain/usecases/search_tv_shows.dart';

part 'tv_show_search_event.dart';
part 'tv_show_search_state.dart';

class TvShowSearchBloc extends Bloc<TvShowSearchEvent, TvShowSearchState> {
  final SearchTvShows _searchTvShows;

  TvShowSearchBloc(this._searchTvShows) : super(TvShowSearchEmptyState()) {
    on<OnQueryChangedEvent>((event, emit) async {
      final query = event.query;
      emit(TvShowSearchLoadingState());
      final result = await _searchTvShows.execute(query);
      result.fold((error) {
        emit(TvShowSearchErrorState(error.message));
      }, (data) {
        emit(TvShowSearchSuccessState(data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
