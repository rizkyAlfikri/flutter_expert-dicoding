import 'package:equatable/equatable.dart';

class TvShow extends Equatable {
  TvShow({
    required this.posterPath,
    required this.popularity,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.firstAirDate,
    required this.genreIds,
    required this.voteCount,
    required this.name,
    required this.originalName,
  });

  String? posterPath;
  double? popularity;
  int? id;
  String? backdropPath;
  double? voteAverage;
  String? overview;
  String? firstAirDate;
  List<int>? genreIds;
  int? voteCount;
  String? name;
  String? originalName;

  TvShow.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  @override
  List<Object?> get props => [
        posterPath,
        popularity,
        id,
        backdropPath,
        voteAverage,
        overview,
        firstAirDate,
        genreIds,
        voteCount,
        name,
        originalName,
      ];
}
