import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/save_tv_watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SaveTvWatchlist usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = SaveTvWatchlist(mockTvShowRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockTvShowRepository.saveTvWatchlist(testTvShowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvShowDetail);
    // assert
    verify(mockTvShowRepository.saveTvWatchlist(testTvShowDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
