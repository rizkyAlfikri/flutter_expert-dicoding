import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail_movie';

  final int id;
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovieDetailPageState();
  }
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(OnFetchMovieDetailEvent(widget.id));
      context
          .read<MovieDetailWatchlistBloc>()
          .add(OnInitMovieWatchlistStatusEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailBlocState>(
        builder: (context, state) {
          if (state is MovieDetailLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailSuccessState) {
            // if (state.message.isNotEmpty) showErrorMessage(state.message);
            return SafeArea(
              child: MovieDetailContent(
                state.movieDetail,
                state.movieRecommendations,
              ),
            );
          } else if (state is MovieDetailErrorState) {
            return Text(state.message);
          } else {
            return const Text('Failed');
          }
        },
      ),
    );
  }
}

class MovieDetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;

  const MovieDetailContent(this.movie, this.recommendations, {Key? key})
      : super(key: key);

  void showErrorMessage(BuildContext context, String errorMessage) {
    final message = errorMessage;
    if (message == MovieDetailWatchlistBloc.watchlistAddSuccessMessage ||
        message == MovieDetailWatchlistBloc.watchlistRemoveSuccessMessage) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else if (message.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(message),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            BlocConsumer<MovieDetailWatchlistBloc,
                                MovieDetailBlocState>(
                              listener: (context, state) {
                                if (state is MovieWatchlistStatusState) {
                                  showErrorMessage(context, state.message);
                                }
                              },
                              builder: (context, state) {
                                if (state is MovieWatchlistStatusState) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      if (!state.isAdded) {
                                        context
                                            .read<MovieDetailWatchlistBloc>()
                                            .add(OnAddMovieWatchlistEvent(
                                                movie));
                                      } else {
                                        context
                                            .read<MovieDetailWatchlistBloc>()
                                            .add(
                                                OnRemoveMovieFromWatchlistEvent(
                                                    movie));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.isAdded
                                            ? const Icon(Icons.check)
                                            : const Icon(Icons.add),
                                        const Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            const Text(
                              'Movie',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendation Movies',
                              style: kHeading6,
                            ),
                            recommendations.isEmpty
                                ? Container()
                                : SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
