import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';

import '../../../../../core/test/dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMovieBloc topRatedMovieBloc;
  final tMovies = testMovieList;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieBloc = TopRatedMovieBloc(mockGetTopRatedMovies);
  });

  group('Top Rated Movie', () {
    test('Initial state should be loading state', () {
      expect(topRatedMovieBloc.state, MovieListLoadingState());
    });

    blocTest<TopRatedMovieBloc, MovieListState>(
      'onFetchTopRatedMovies success should emit NowPlayingMovieListState and call execute at mockGetTopRatedMovies',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return topRatedMovieBloc;
      },
      act: (bloc) => {bloc.add(const OnFetchTopRatedMovies())},
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieListLoadingState(),
        TopRatedMovieListState(tMovies),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<TopRatedMovieBloc, MovieListState>(
      'onFetchTopRatedMovies error should emit MovieListErrorState and call execute at mockGetTopRatedMovies',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(const OnFetchTopRatedMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieListLoadingState(),
        const MovieListErrorState('Failed'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
