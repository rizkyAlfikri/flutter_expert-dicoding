import 'package:equatable/equatable.dart';

import 'tv_show_model.dart';

class TvShowResponse extends Equatable {
  TvShowResponse({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  final int page;
  final List<TvShowModel> results;
  final int totalResults;
  final int totalPages;

  factory TvShowResponse.fromMap(Map<String, dynamic> json) => TvShowResponse(
        page: json["page"],
        results: List<TvShowModel>.from(
            json["results"].map((x) => TvShowModel.fromMap(x))),
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_results": totalResults,
        "total_pages": totalPages,
      };

  @override
  List<Object?> get props => [
        page,
        results,
        totalResults,
        totalPages,
      ];
}
