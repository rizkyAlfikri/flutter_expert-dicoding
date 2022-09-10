import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_tv_watchlist_status.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTvWatchListStatus usecase;
  late MockTvShowRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvShowRepository();
    usecase = GetTvWatchListStatus(mockTvShowRepository);
  });

  test('should get tv watchlist status from repository', () async {
    // arrange
    when(mockTvShowRepository.isAddedToTvWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
