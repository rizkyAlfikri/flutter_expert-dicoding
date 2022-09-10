import 'package:core/domain/entities/tv_show.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_tv_show_recomendations.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTvShowRecomendations usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvShowRecomendations(mockTvShowRepository);
  });

  const tId = 1;
  final tTvShow = <TvShow>[];

  test('should get list of tv recommendations from the repository', () async {
    // arrange
    when(mockTvShowRepository.getTvShowRecommendations(tId))
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvShow));
  });
}
