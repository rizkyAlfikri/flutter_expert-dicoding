import 'package:core/domain/entities/tv_show.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_now_paling__tv_shows.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvShows usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetNowPlayingTvShows(mockTvShowRepository);
  });

  final tTvShow = <TvShow>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvShowRepository.getNowPlayingTvShows())
        .thenAnswer((_) async => Right(tTvShow));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShow));
  });
}
