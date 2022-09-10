import 'package:core/domain/entities/tv_show.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search_tv_show/domain/usecases/search_tv_shows.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SearchTvShows usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = SearchTvShows(mockTvShowRepository);
  });

  final tTvShows = <TvShow>[];
  const tQuery = 'Naruto';

  test('Should get list of tv shows from repository', () async {
    // arrange
    when(mockTvShowRepository.searchTvShows(tQuery))
        .thenAnswer((_) async => Right(tTvShows));

    // act
    final result = await usecase.execute(tQuery);

    // assert
    expect(result, Right(tTvShows));
  });
}
