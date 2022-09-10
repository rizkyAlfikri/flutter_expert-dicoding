import 'package:core/domain/entities/tv_show.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv_shows.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvShows usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTopRatedTvShows(mockTvShowRepository);
  });

  final tTvShow = <TvShow>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvShowRepository.getTopRatedTvShows())
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShow));
  });
}
