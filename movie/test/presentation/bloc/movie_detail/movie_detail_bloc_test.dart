import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/movie.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail, GetMovieRecommendations])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  late MovieDetailBloc movieDetailBloc;
  late MovieDetailWatchlistBloc movieDetailWatchlistBloc;

  setUp(
    () {
      mockGetMovieDetail = MockGetMovieDetail();
      mockGetMovieRecommendations = MockGetMovieRecommendations();

      movieDetailBloc = MovieDetailBloc(
        mockGetMovieDetail,
        mockGetMovieRecommendations,
      );
    },
  );

  final tMovieDetail = testMovieDetail;
  final tMovieRecomendations = <Movie>[testMovie];

  group('movie detail bloc', () {
    test('Initial state should be loading state', () {
      expect(movieDetailBloc.state, MovieDetailLoadingState());
    });

    blocTest<MovieDetailBloc, MovieDetailBlocState>(
      'fetch movie detail success and fetch movie recomendations success should emit MovieDetailSuccessState',
      build: () {
        when(mockGetMovieDetail.execute(557))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(557))
            .thenAnswer((_) async => Right(tMovieRecomendations));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchMovieDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailLoadingState(),
        MovieDetailSuccessState(tMovieDetail, tMovieRecomendations),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(557));
        verify(mockGetMovieRecommendations.execute(557));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailBlocState>(
      'fetch movie detail error and fetch movie recomendations success should emit MovieDetailErrorState',
      build: () {
        when(mockGetMovieDetail.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(557))
            .thenAnswer((_) async => Right(tMovieRecomendations));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchMovieDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailLoadingState(),
        const MovieDetailErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(557));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailBlocState>(
      'fetch movie detail success and fetch movie recomendations error should emit MovieDetailErrorState',
      build: () {
        when(mockGetMovieDetail.execute(557))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchMovieDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailLoadingState(),
        const MovieDetailErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(557));
        verify(mockGetMovieRecommendations.execute(557));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailBlocState>(
      'fetch movie detail error and fetch movie recomendations error should emit MovieDetailErrorState',
      build: () {
        when(mockGetMovieDetail.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(557))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnFetchMovieDetailEvent(557)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieDetailLoadingState(),
        const MovieDetailErrorState('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(557));
        verify(mockGetMovieRecommendations.execute(557));
      },
    );
  });
}
