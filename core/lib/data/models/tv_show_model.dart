import 'package:core/domain/entities/tv_show.dart';
import 'package:equatable/equatable.dart';

class TvShowModel extends Equatable {
  TvShowModel({
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

  final String posterPath;
  final double popularity;
  final int id;
  final String backdropPath;
  final double voteAverage;
  final String overview;
  final String firstAirDate;
  final List<int> genreIds;
  final int voteCount;
  final String name;
  final String originalName;

  factory TvShowModel.fromMap(Map<String, dynamic> json) => TvShowModel(
        posterPath: json["poster_path"] ?? "",
        popularity: json["popularity"].toDouble() ?? 0.0,
        id: json["id"],
        backdropPath: json["backdrop_path"] ?? "",
        voteAverage: json["vote_average"].toDouble() ?? 0.0,
        overview: json["overview"] ?? "",
        firstAirDate: json["first_air_date"] ?? '',
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        voteCount: json["vote_count"] ?? 0.0,
        name: json["name"] ?? '',
        originalName: json["original_name"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "poster_path": posterPath,
        "popularity": popularity,
        "id": id,
        "backdrop_path": backdropPath,
        "vote_average": voteAverage,
        "overview": overview,
        "first_air_date": firstAirDate,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "vote_count": voteCount,
        "name": name,
        "original_name": originalName,
      };

  TvShow toEntity() {
    return TvShow(
      posterPath: posterPath,
      popularity: popularity,
      id: id,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      overview: overview,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      voteCount: voteCount,
      name: name,
      originalName: originalName,
    );
  }

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
