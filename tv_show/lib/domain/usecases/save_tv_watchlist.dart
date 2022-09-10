import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class SaveTvWatchlist {
  final TvShowRepository repository;

  SaveTvWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tv) {
    return repository.saveTvWatchlist(tv);
  }
}
