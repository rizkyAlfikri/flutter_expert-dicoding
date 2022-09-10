import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/remove_tv_watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvWatchlist usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = RemoveTvWatchlist(mockTvShowRepository);
  });

  test('should remove watchlist tv from repository', () async {
    // arrange
    when(mockTvShowRepository.removeTvWatchlist(testTvShowDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvShowDetail);
    // assert
    verify(mockTvShowRepository.removeTvWatchlist(testTvShowDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
