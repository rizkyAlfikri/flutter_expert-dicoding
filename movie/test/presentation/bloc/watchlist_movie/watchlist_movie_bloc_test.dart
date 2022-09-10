import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMovieBloc watchlistMovieBloc;
  final tMovies = testMovieList;

  setUp(
    () {
      mockGetWatchlistMovies = MockGetWatchlistMovies();
      watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
    },
  );

  group('Watchlist movies', () {
    test('Initial state should be loading state', () {
      expect(watchlistMovieBloc.state, WatchlistMovieLoadingState());
    });

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'onFetchWatchlistMovies success should emit WatchlistMoviesSuccessState and call execute mockGetWatchlistMovies',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const OnFetchWatchlistMoviesEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [WatchlistMoviesSuccessState(tMovies)],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'onFetchWatchlistMovies error should emit WatchlistMovieErrorState and call execute mockGetWatchlistMovies',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(const OnFetchWatchlistMoviesEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [const WatchlistMovieErrorState('Failed')],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });
}
