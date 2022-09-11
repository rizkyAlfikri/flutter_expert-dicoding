import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_show/tv_show.dart';

class TvShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-show';

  final int id;

  const TvShowDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<TvShowDetailPage> createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowDetailBloc>().add(OnFetchTvShowDetailEvent(widget.id));
      context
          .read<TvShowDetailWatchlistBloc>()
          .add(OnInitTvShowWatchlistStatusEvent(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvShowDetailSuccessState) {
            return SafeArea(
              child: TvShowDetailContent(
                tvShowDetail: state.tvShowDetail,
                recommendations: state.tvShowRecommendations,
              ),
            );
          } else if (state is TvShowDetailErrorState) {
            return Text(state.message);
          } else {
            return const Text("Failed");
          }
        },
      ),
    );
  }
}

class TvShowDetailContent extends StatelessWidget {
  final TvShowDetail tvShowDetail;
  final List<TvShow> recommendations;

  const TvShowDetailContent({
    Key? key,
    required this.tvShowDetail,
    required this.recommendations,
  }) : super(key: key);

  void showErrorMessage(BuildContext context, String errorMessage) {
    CrashlyticTracker.recordCrashEvent(errorMessage);
    final message = errorMessage;
    if (message == TvShowDetailWatchlistBloc.watchlistAddSuccessMessage ||
        message == TvShowDetailWatchlistBloc.watchlistRemoveSuccessMessage) {
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
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvShowDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
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
                              tvShowDetail.name,
                              style: kHeading5,
                            ),
                            BlocConsumer<TvShowDetailWatchlistBloc,
                                TvShowDetailState>(
                              listener: (context, state) {
                                if (state is TvShowWatchlistStatusState) {
                                  showErrorMessage(context, state.message);
                                }
                              },
                              builder: (context, state) {
                                if (state is TvShowWatchlistStatusState) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      if (!state.isAdded) {
                                        AnalyticTracker
                                            .sendTvFavoriteAnalyticsEvent(
                                                tvShowDetail, true);
                                        context
                                            .read<TvShowDetailWatchlistBloc>()
                                            .add(OnAddTvShowWatchlistEvent(
                                                tvShowDetail));
                                      } else {
                                        AnalyticTracker
                                            .sendTvFavoriteAnalyticsEvent(
                                                tvShowDetail, false);
                                        context
                                            .read<TvShowDetailWatchlistBloc>()
                                            .add(
                                                OnRemoveTvShowFromWatchlistEvent(
                                                    tvShowDetail));
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
                              'Tv Show',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              _showGenres(tvShowDetail.genres),
                            ),
                            Text(
                              _showDuration(tvShowDetail.episodeRunTime.first),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvShowDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvShowDetail.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvShowDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations Tv Shows',
                              style: kHeading6,
                            ),
                            recommendations.isEmpty
                                ? Container()
                                : SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tvShow = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvShowDetailPage.ROUTE_NAME,
                                                arguments: tvShow.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
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
