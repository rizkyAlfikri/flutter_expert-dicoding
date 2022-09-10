import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_watchlist_bloc_test.mocks.dart';

@GenerateNiceMocks(
  [
    MockSpec<GetWatchListStatus>(),
    MockSpec<SaveWatchlist>(),
    MockSpec<RemoveWatchlist>()
  ],
)
void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  late MovieDetailWatchlistBloc movieDetailWatchlistBloc;

  setUp(
    () {
      mockGetWatchListStatus = MockGetWatchListStatus();
      mockSaveWatchlist = MockSaveWatchlist();
      mockRemoveWatchlist = MockRemoveWatchlist();

      movieDetailWatchlistBloc = MovieDetailWatchlistBloc(
        mockGetWatchListStatus,
        mockSaveWatchlist,
        mockRemoveWatchlist,
      );
    },
  );

  final tMovieDetail = testMovieDetail;

  group(
    'movie detail watchlist',
    () {
      test('Initial state should be loading state', () {
        expect(movieDetailWatchlistBloc.state, MovieDetailLoadingState());
      });

      blocTest<MovieDetailWatchlistBloc, MovieDetailBlocState>(
          'add movie watchlist success should emit MovieWatchlistStatusState and call execute in saveWatchlist',
          build: () {
            when(mockSaveWatchlist.execute(tMovieDetail))
                .thenAnswer((_) async => const Right('Success'));
            when(mockGetWatchListStatus.execute(557))
                .thenAnswer((_) async => false);
            return movieDetailWatchlistBloc;
          },
          act: (bloc) => bloc.add(OnAddMovieWatchlistEvent(tMovieDetail)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                const MovieWatchlistStatusState(false, 'Success'),
              ],
          verify: (bloc) {
            verify(mockSaveWatchlist.execute(tMovieDetail));
            verifyNever(mockGetWatchListStatus.execute(557));
          });

      blocTest<MovieDetailWatchlistBloc, MovieDetailBlocState>(
          'add movie watchlist error should emit MovieWatchlistStatusState and call execute in saveWatchlist',
          build: () {
            when(mockSaveWatchlist.execute(tMovieDetail))
                .thenAnswer((_) async => Left(ServerFailure('Failure')));
            when(mockGetWatchListStatus.execute(557))
                .thenAnswer((_) async => false);
            return movieDetailWatchlistBloc;
          },
          act: (bloc) => bloc.add(OnAddMovieWatchlistEvent(tMovieDetail)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                const MovieWatchlistStatusState(false, 'Failure'),
              ],
          verify: (bloc) {
            verify(mockSaveWatchlist.execute(tMovieDetail));
            verifyNever(mockGetWatchListStatus.execute(557));
          });

      blocTest<MovieDetailWatchlistBloc, MovieDetailBlocState>(
          'remove movie watchlist success should emit MovieWatchlistStatusState and call execute in saveWatchlist',
          build: () {
            when(mockRemoveWatchlist.execute(tMovieDetail))
                .thenAnswer((_) async => const Right('Success'));
            when(mockGetWatchListStatus.execute(557))
                .thenAnswer((_) async => false);
            return movieDetailWatchlistBloc;
          },
          act: (bloc) =>
              bloc.add(OnRemoveMovieFromWatchlistEvent(tMovieDetail)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                const MovieWatchlistStatusState(false, 'Success'),
              ],
          verify: (bloc) {
            verify(mockRemoveWatchlist.execute(tMovieDetail));
            verifyNever(mockGetWatchListStatus.execute(557));
          });

      blocTest<MovieDetailWatchlistBloc, MovieDetailBlocState>(
          'remove movie watchlist error should emit MovieWatchlistStatusState and call execute in saveWatchlist',
          build: () {
            when(mockRemoveWatchlist.execute(tMovieDetail))
                .thenAnswer((_) async => Left(ServerFailure('Failure')));
            when(mockGetWatchListStatus.execute(557))
                .thenAnswer((_) async => false);
            return movieDetailWatchlistBloc;
          },
          act: (bloc) =>
              bloc.add(OnRemoveMovieFromWatchlistEvent(tMovieDetail)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
                const MovieWatchlistStatusState(false, 'Failure'),
              ],
          verify: (bloc) {
            verify(mockRemoveWatchlist.execute(tMovieDetail));
            verifyNever(mockGetWatchListStatus.execute(557));
          });

      blocTest<MovieDetailWatchlistBloc, MovieDetailBlocState>(
        'onInitMovieWatchList should emit MovieWatchlistStatusState and call execute in getWatchListStatus',
        build: () {
          when(mockGetWatchListStatus.execute(557))
              .thenAnswer((_) async => true);
          return movieDetailWatchlistBloc;
        },
        act: (bloc) => bloc.add(const OnInitMovieWatchlistStatusEvent(557)),
        wait: const Duration(milliseconds: 500),
        expect: () => {
          const MovieWatchlistStatusState(true, ''),
        },
        verify: (bloc) {
          verify(mockGetWatchListStatus.execute(557));
        },
      );
    },
  );
}
