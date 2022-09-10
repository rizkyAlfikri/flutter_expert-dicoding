import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_show.dart';
import '../../utils/constants.dart';

class ItemList extends StatelessWidget {
  final List<Movie> movies;
  final List<TvShow> tvShows;
  final String route;

  ItemList({
    required this.movies,
    required this.tvShows,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final dataLength = movies.isNotEmpty ? movies.length : tvShows.length;
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final id = movies.isNotEmpty ? movies[index].id : tvShows[index].id;
          final posterPath = movies.isNotEmpty
              ? movies[index].posterPath
              : tvShows[index].posterPath;

          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, route, arguments: id);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL$posterPath',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: dataLength,
      ),
    );
  }
}
