import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

  final tMovies = testMovieList;
  group('Popular Movie', () {
    test('Initial state should be loading state', () {
      expect(popularMovieBloc.state, MovieListLoadingState());
    });

    blocTest<PopularMovieBloc, MovieListState>(
      'onFetchNowPlayingMovies success should emit NowPlayingMovieListState and call execute at mockGetPopularMovies',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return popularMovieBloc;
      },
      act: (bloc) => {bloc.add(const OnFetchPopularMovies())},
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieListLoadingState(),
        PolularMovieListState(tMovies),
      ],
      verify: (bloc) async {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMovieBloc, MovieListState>(
      'onFetchNowPlayingMovies error should emit MovieListErrorState and call execute at mockGetPopularMovies',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(const OnFetchPopularMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieListLoadingState(),
        const MovieListErrorState('Failed'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
