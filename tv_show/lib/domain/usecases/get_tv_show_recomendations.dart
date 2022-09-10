import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvShowRecomendations {
  final TvShowRepository repository;

  GetTvShowRecomendations(this.repository);

  Future<Either<Failure, List<TvShow>>> execute(int id) {
    return repository.getTvShowRecommendations(id);
  }
}
