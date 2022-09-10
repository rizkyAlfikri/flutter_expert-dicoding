import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_now_paling__tv_shows.dart';
import 'package:tv_show/domain/usecases/get_populart_tv_shows.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:tv_show/tv_show.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_show_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvShows, GetPopularTvShows, GetTopRatedTvShows])
void main() {
  final tTvShows = testTvShowList;

  group('Now Playing Tv Show', () {
    late MockGetNowPlayingTvShows mockGetNowPlayingTvShows;
    late NowPlayingTvShowBloc nowPlayingTvShowBloc;

    setUp(() {
      mockGetNowPlayingTvShows = MockGetNowPlayingTvShows();
      nowPlayingTvShowBloc = NowPlayingTvShowBloc(mockGetNowPlayingTvShows);
    });

    test('Initial state should be loading state', () {
      expect(nowPlayingTvShowBloc.state, TvShowListLoadingState());
    });

    blocTest<NowPlayingTvShowBloc, TvShowListState>(
      'onFetchNowPlayingTvShows with success should emit NowPlayingTvShowListState',
      build: () {
        when(mockGetNowPlayingTvShows.execute())
            .thenAnswer((_) async => Right(tTvShows));
        return nowPlayingTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchNowPlayingTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TvShowListLoadingState(), NowPlayingTvShowListState(tTvShows)],
      verify: (bloc) => {verify(mockGetNowPlayingTvShows.execute())},
    );

    blocTest<NowPlayingTvShowBloc, TvShowListState>(
      'onFetchNowPlayingTvShows with error should emit TvShowListErrorState',
      build: () {
        when(mockGetNowPlayingTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return nowPlayingTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchNowPlayingTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoadingState(),
        const TvShowListErrorState('Failed'),
      ],
      verify: (bloc) => {verify(mockGetNowPlayingTvShows.execute())},
    );
  });

  group('Popular Tv Show', () {
    late MockGetPopularTvShows mockGetPopularTvShows;
    late PopularTvShowBloc popularTvShowBloc;

    setUp(() {
      mockGetPopularTvShows = MockGetPopularTvShows();
      popularTvShowBloc = PopularTvShowBloc(mockGetPopularTvShows);
    });

    test('Initial state should be loading state', () {
      expect(popularTvShowBloc.state, TvShowListLoadingState());
    });

    blocTest<PopularTvShowBloc, TvShowListState>(
      'onFetchPopularTvShows with success should emit PolularTvShowListState',
      build: () {
        when(mockGetPopularTvShows.execute())
            .thenAnswer((_) async => Right(tTvShows));
        return popularTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchPopularTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TvShowListLoadingState(), PolularTvShowListState(tTvShows)],
      verify: (bloc) => {verify(mockGetPopularTvShows.execute())},
    );

    blocTest<PopularTvShowBloc, TvShowListState>(
      'onFetchPopularTvShows with error should emit TvShowListErrorState',
      build: () {
        when(mockGetPopularTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return popularTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchPopularTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoadingState(),
        const TvShowListErrorState('Failed'),
      ],
      verify: (bloc) => {verify(mockGetPopularTvShows.execute())},
    );
  });

  group('Top Rated Tv Show', () {
    late MockGetTopRatedTvShows mockGetTopRatedTvShows;
    late TopRatedTvShowBloc topRatedTvShowBloc;

    setUp(() {
      mockGetTopRatedTvShows = MockGetTopRatedTvShows();
      topRatedTvShowBloc = TopRatedTvShowBloc(mockGetTopRatedTvShows);
    });

    test('Initial state should be loading state', () {
      expect(topRatedTvShowBloc.state, TvShowListLoadingState());
    });

    blocTest<TopRatedTvShowBloc, TvShowListState>(
      'onFetchTopRatedTvShows with success should emit TopRatedTvShowListState',
      build: () {
        when(mockGetTopRatedTvShows.execute())
            .thenAnswer((_) async => Right(tTvShows));
        return topRatedTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTopRatedTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TvShowListLoadingState(), TopRatedTvShowListState(tTvShows)],
      verify: (bloc) => {verify(mockGetTopRatedTvShows.execute())},
    );

    blocTest<TopRatedTvShowBloc, TvShowListState>(
      'onFetchTopRatedTvShows with error should emit TvShowListErrorState',
      build: () {
        when(mockGetTopRatedTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return topRatedTvShowBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTopRatedTvShows()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowListLoadingState(),
        const TvShowListErrorState('Failed'),
      ],
      verify: (bloc) => {verify(mockGetTopRatedTvShows.execute())},
    );
  });
}
