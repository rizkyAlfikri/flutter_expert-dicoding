import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_show.dart';
import '../../styles/text_styles.dart';
import '../../utils/constants.dart';

class ItemCard extends StatelessWidget {
  final Movie? movie;
  final TvShow? tvShow;
  final String route;

  ItemCard({
    this.movie,
    this.tvShow,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    String? title = (movie != null) ? movie?.title : tvShow?.name;
    int? id = (movie != null) ? movie?.id : tvShow?.id;
    String? overview = (movie != null) ? movie?.overview : tvShow?.overview;
    String? posterPath =
        (movie != null) ? movie?.posterPath : tvShow?.posterPath;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            route,
            arguments: id,
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    SizedBox(height: 16),
                    Text(
                      overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL$posterPath',
                  width: 80,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
