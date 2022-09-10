import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search_tv_show/domain/usecases/search_tv_shows.dart';
import 'package:search_tv_show/presentation/bloc/tv_show_search_bloc.dart';

import 'search_tv_show_bloc_test.mocks.dart';

@GenerateMocks([SearchTvShows])
void main() {
  late TvShowSearchBloc tvShowSearchBloc;
  late MockSearchTvShows searchTvShows;

  setUp(
    () {
      searchTvShows = MockSearchTvShows();
      tvShowSearchBloc = TvShowSearchBloc(searchTvShows);
    },
  );

  final testTvShow = TvShow(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tTvShowsList = <TvShow>[testTvShow];
  const tQuery = 'spiderman';

  test('Initial state should be empty', () {
    expect(tvShowSearchBloc.state, TvShowSearchEmptyState());
  });

  blocTest<TvShowSearchBloc, TvShowSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(searchTvShows.execute(tQuery))
          .thenAnswer((_) async => Right(tTvShowsList));
      return tvShowSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChangedEvent(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () =>
        [TvShowSearchLoadingState(), TvShowSearchSuccessState(tTvShowsList)],
    verify: (bloc) {
      verify(searchTvShows.execute(tQuery));
    },
  );

  blocTest<TvShowSearchBloc, TvShowSearchState>(
      'Should emit [Loading, HasData] when get search is unsuccessful',
      build: () {
        when(searchTvShows.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvShowSearchBloc;
      },
      act: (bloc) => bloc.add(OnQueryChangedEvent(tQuery)),
      expect: () => {
            TvShowSearchLoadingState(),
            const TvShowSearchErrorState('Server Failure'),
          },
      wait: const Duration(milliseconds: 500),
      verify: (bloc) {
        verify(searchTvShows.execute(tQuery));
      });
}
