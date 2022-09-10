import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_populart_tv_shows.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvShows usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetPopularTvShows(mockTvShowRepository);
  });

  final tTvShow = <TvShow>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvShowRepository.getPopularTvShows())
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShow));
  });
}
