import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_tv_show_detail.dart';
import 'package:tv_show/domain/usecases/get_tv_show_recomendations.dart';
import 'package:tv_show/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv_show/domain/usecases/remove_tv_watchlist.dart';
import 'package:tv_show/domain/usecases/save_tv_watchlist.dart';
import 'package:tv_show/presentation/bloc/tv_show_detail/tv_show_detail_bloc.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_show_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvShowDetail,
  GetTvShowRecomendations,
  GetTvWatchListStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist
])
void main() {
  final tTvShowDetail = testTvShowDetail;
  final tTvShows = testTvShowList;
  group('Tv Show Detail', () {
    late MockGetTvShowDetail mockGetTvShowDetail;
    late MockGetTvShowRecomendations mockGetTvShowRecomendations;

    late TvShowDetailBloc tvShowDetailBloc;

    setUp(() {
      mockGetTvShowDetail = MockGetTvShowDetail();
      mockGetTvShowRecomendations = MockGetTvShowRecomendations();

      tvShowDetailBloc = TvShowDetailBloc(
        mockGetTvShowDetail,
        mockGetTvShowRecomendations,
      );
    });

    test('Initial state should be loading state', () {
      expect(tvShowDetailBloc.state, TvShowDetailLoadingState());
    });

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'onFetchTvShowDetail with getTvShowDetail and getTvShowRecommendations success should emit TvShowDetailSuccessState',
      build: () {
        when(mockGetTvShowDetail.execute(557))
            .thenAnswer((_) async => Right(tTvShowDetail));
        when(mockGetTvShowRecomendations.execute(557))
            .thenAnswer((_) async => Right(tTvShows));

        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTvShowDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvShowDetailLoadingState(),
        TvShowDetailSuccessState(tTvShowDetail, tTvShows)
      ],
      verify: (bloc) => [
        mockGetTvShowDetail.execute(557),
        mockGetTvShowRecomendations.execute(557)
      ],
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'onFetchTvShowDetail with getTvShowDetail error and getTvShowRecommendations success should emit TvShowDetailErrorState',
      build: () {
        when(mockGetTvShowDetail.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetTvShowRecomendations.execute(557))
            .thenAnswer((_) async => Right(tTvShows));

        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTvShowDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TvShowDetailLoadingState(), const TvShowDetailErrorState('Failed')],
      verify: (bloc) => [
        mockGetTvShowDetail.execute(557),
        mockGetTvShowRecomendations.execute(557)
      ],
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'onFetchTvShowDetail with getTvShowDetail success and getTvShowRecommendations error should emit TvShowDetailErrorState',
      build: () {
        when(mockGetTvShowDetail.execute(557))
            .thenAnswer((_) async => Right(tTvShowDetail));
        when(mockGetTvShowRecomendations.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));

        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTvShowDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TvShowDetailLoadingState(), const TvShowDetailErrorState('Failed')],
      verify: (bloc) => [
        mockGetTvShowDetail.execute(557),
        mockGetTvShowRecomendations.execute(557)
      ],
    );

    blocTest<TvShowDetailBloc, TvShowDetailState>(
      'onFetchTvShowDetail with getTvShowDetail error and getTvShowRecommendations error should emit TvShowDetailErrorState',
      build: () {
        when(mockGetTvShowDetail.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetTvShowRecomendations.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));

        return tvShowDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTvShowDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TvShowDetailLoadingState(), const TvShowDetailErrorState('Failed')],
      verify: (bloc) => [
        mockGetTvShowDetail.execute(557),
        mockGetTvShowRecomendations.execute(557)
      ],
    );
  });

  group('Tv Show Detail Watchlist', () {
    late MockGetTvWatchListStatus mockGetTvWatchListStatus;
    late MockSaveTvWatchlist mockSaveTvWatchlist;
    late MockRemoveTvWatchlist mockRemoveTvWatchlist;

    late TvShowDetailWatchlistBloc tvShowDetailWatchlistBloc;

    setUp(() {
      mockGetTvWatchListStatus = MockGetTvWatchListStatus();
      mockSaveTvWatchlist = MockSaveTvWatchlist();
      mockRemoveTvWatchlist = MockRemoveTvWatchlist();

      tvShowDetailWatchlistBloc = TvShowDetailWatchlistBloc(
        mockGetTvWatchListStatus,
        mockSaveTvWatchlist,
        mockRemoveTvWatchlist,
      );
    });

    blocTest<TvShowDetailWatchlistBloc, TvShowDetailState>(
      'onAddTvShowWatchList with SaveTvWatchlist success should emit TvShowWatchlistStatusState ',
      build: () {
        when(mockSaveTvWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => const Right('Success'));
        when(mockGetTvWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return tvShowDetailWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnAddTvShowWatchlistEvent(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const TvShowWatchlistStatusState(true, 'Success'),
      ],
      verify: (bloc) => [
        verify(mockSaveTvWatchlist.execute(tTvShowDetail)),
        verify(mockGetTvWatchListStatus.execute(1)),
      ],
    );

    blocTest<TvShowDetailWatchlistBloc, TvShowDetailState>(
      'onAddTvShowWatchList with SaveTvWatchlist error should emit TvShowWatchlistStatusState ',
      build: () {
        when(mockSaveTvWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetTvWatchListStatus.execute(1))
            .thenAnswer((_) async => false);
        return tvShowDetailWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnAddTvShowWatchlistEvent(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const TvShowWatchlistStatusState(false, 'Failed'),
      ],
      verify: (bloc) => [
        verify(mockSaveTvWatchlist.execute(tTvShowDetail)),
        verify(mockGetTvWatchListStatus.execute(1)),
      ],
    );

    blocTest<TvShowDetailWatchlistBloc, TvShowDetailState>(
      'onRemoveTvShowWathclist with RemoveTvWatchlist success should emit TvShowWatchlistStatusState ',
      build: () {
        when(mockRemoveTvWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => const Right('Success'));
        when(mockGetTvWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return tvShowDetailWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnRemoveTvShowFromWatchlistEvent(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const TvShowWatchlistStatusState(true, 'Success'),
      ],
      verify: (bloc) => [
        verify(mockRemoveTvWatchlist.execute(tTvShowDetail)),
        verify(mockGetTvWatchListStatus.execute(1)),
      ],
    );

    blocTest<TvShowDetailWatchlistBloc, TvShowDetailState>(
      'onRemoveTvShowWathclist with RemoveTvWatchlist error should emit TvShowWatchlistStatusState ',
      build: () {
        when(mockRemoveTvWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetTvWatchListStatus.execute(1))
            .thenAnswer((_) async => false);
        return tvShowDetailWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnRemoveTvShowFromWatchlistEvent(tTvShowDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const TvShowWatchlistStatusState(false, 'Failed'),
      ],
      verify: (bloc) => [
        verify(mockRemoveTvWatchlist.execute(tTvShowDetail)),
        verify(mockGetTvWatchListStatus.execute(1)),
      ],
    );

    blocTest<TvShowDetailWatchlistBloc, TvShowDetailState>(
      'onInitTvShowWatchList should emit TvShowWatchlistStatusState',
      build: () {
        when(mockGetTvWatchListStatus.execute(1)).thenAnswer((_) async => true);
        return tvShowDetailWatchlistBloc;
      },
      act: (bloc) => bloc.add(const OnInitTvShowWatchlistStatusEvent(1)),
      wait: const Duration(milliseconds: 500),
      expect: () => {
        const TvShowWatchlistStatusState(true, ''),
      },
      verify: (bloc) => [
        verify(mockGetTvWatchListStatus.execute(1)),
      ],
    );
  });
}
