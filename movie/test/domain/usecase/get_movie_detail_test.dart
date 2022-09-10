import 'package:core/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetMovieDetail getMovieDetail;
  late MockMovieRepository mockMovieRepository;

  setUp(
    () {
      mockMovieRepository = MockMovieRepository();
      getMovieDetail = GetMovieDetail(mockMovieRepository);
    },
  );

  MovieDetail tMovieDetail = testMovieDetail;

  test('should get movie detail from repository', () async {
    // arrange
    when(mockMovieRepository.getMovieDetail(557))
        .thenAnswer((_) async => Right(tMovieDetail));

    // act
    final result = await getMovieDetail.execute(557);

    // assert
    expect(result, Right(tMovieDetail));
  });
}
