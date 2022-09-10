import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/movie.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMovieBloc nowPlayingMovieBloc;

  final tMovies = testMovieList;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMovieBloc = NowPlayingMovieBloc(mockGetNowPlayingMovies);
  });

  group('Now Playing Movie', () {
    test('Initial state should be loading state', () {
      expect(nowPlayingMovieBloc.state, MovieListLoadingState());
    });

    blocTest<NowPlayingMovieBloc, MovieListState>(
      'onFetchNowPlayingMovies success should emit NowPlayingMovieListState and call execute at mockGetNowPlayingMovies',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => {bloc.add(const OnFetchNowPlayingMovies())},
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieListLoadingState(),
        NowPlayingMovieListState(tMovies),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingMovieBloc, MovieListState>(
      'onFetchNowPlayingMovies error should emit MovieListErrorState and call execute at mockGetNowPlayingMovies',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return nowPlayingMovieBloc;
      },
      act: (bloc) => bloc.add(const OnFetchNowPlayingMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieListLoadingState(),
        const MovieListErrorState('Failed'),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });
}
