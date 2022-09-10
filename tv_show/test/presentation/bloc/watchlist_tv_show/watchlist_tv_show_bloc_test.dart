import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:tv_show/tv_show.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_tv_show_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvShows])
main() {
  final tTvShows = testTvShowList;
  group('Watchlist Tv Show', () {
    late MockGetWatchlistTvShows mockGetWatchlistTvShows;
    late WatchlistTvShowBloc watchlistTvShowBloc;

    setUp(() {
      mockGetWatchlistTvShows = MockGetWatchlistTvShows();
      watchlistTvShowBloc = WatchlistTvShowBloc(mockGetWatchlistTvShows);
    });

    test('Initial state should be loading state', () {
      expect(watchlistTvShowBloc.state, WatchlistTvShowLoadingState());
    });

    blocTest<WatchlistTvShowBloc, WatchlistTvShowState>(
      'OnFetchWatchlistTvShowsEvent with success should emit WatchlistTvShowsSuccessState',
      build: () {
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Right(tTvShows));
        return watchlistTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchWatchlistTvShowsEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [WatchlistTvShowsSuccessState(tTvShows)],
      verify: (bloc) => {verify(mockGetWatchlistTvShows.execute())},
    );

    blocTest<WatchlistTvShowBloc, WatchlistTvShowState>(
      'OnFetchWatchlistTvShowsEvent with error should emit WatchlistTvShowErrorState',
      build: () {
        when(mockGetWatchlistTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return watchlistTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchWatchlistTvShowsEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const WatchlistTvShowErrorState('Failed'),
      ],
      verify: (bloc) => {verify(mockGetWatchlistTvShows.execute())},
    );
  });
}
