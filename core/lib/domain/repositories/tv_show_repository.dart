import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TvShowRepository {
  Future<Either<Failure, List<TvShow>>> getNowPlayingTvShows();
  Future<Either<Failure, List<TvShow>>> getPopularTvShows();
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShows();
  Future<Either<Failure, TvShowDetail>> getTvShowsDetail(int id);
  Future<Either<Failure, List<TvShow>>> getTvShowRecommendations(int id);
  Future<Either<Failure, List<TvShow>>> searchTvShows(String query);
  Future<Either<Failure, String>> saveTvWatchlist(TvShowDetail tvShow);
  Future<Either<Failure, String>> removeTvWatchlist(TvShowDetail tvShow);
  Future<Either<Failure, List<TvShow>>> getWatchlistTvShows();
  Future<bool> isAddedToTvWatchlist(int id);
}
