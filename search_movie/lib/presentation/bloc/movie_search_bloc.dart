import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_movie/domain/usecase/search_movies.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(MovieSearchEmptyState()) {
    on<OnQueryChangedEvent>((event, emit) async {
      final query = event.query;
      emit(MovieSearchLoadingState());
      final result = await _searchMovies.execute(query);
      result.fold((error) {
        emit(MovieSearchErrorState(error.message));
      }, (data) {
        emit(MovieSearchSuccessState(data));
      });
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
