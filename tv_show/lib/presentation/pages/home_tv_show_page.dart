import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search_tv_show/search_tv_show.dart';
import 'package:tv_show/presentation/pages/popular_tv_show_page.dart';
import 'package:tv_show/presentation/pages/top_rated_tv_show_page.dart';
import 'package:tv_show/presentation/pages/tv_show_detail_page.dart';
import 'package:tv_show/tv_show.dart';

class HomeTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv-show';
  const HomeTvShowPage({Key? key}) : super(key: key);

  @override
  State<HomeTvShowPage> createState() => HomeTvShowPageState();
}

class HomeTvShowPageState extends State<HomeTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<NowPlayingTvShowBloc>()
          .add(const OnFetchNowPlayingTvShows());
      context.read<PopularTvShowBloc>().add(const OnFetchPopularTvShows());
      context.read<TopRatedTvShowBloc>().add(const OnFetchTopRatedTvShows());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ditonton Tv Shows'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvShowPage.ROUTE_NAME);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingTvShowBloc, TvShowListState>(
                  builder: (context, state) {
                if (state is TvShowListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingTvShowListState) {
                  return ItemList(
                    movies: const [],
                    tvShows: state.tvShows,
                    route: TvShowDetailPage.ROUTE_NAME,
                  );
                } else if (state is TvShowListErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              }),
              SubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvShowPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvShowBloc, TvShowListState>(
                  builder: (context, state) {
                if (state is TvShowListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PolularTvShowListState) {
                  return ItemList(
                    movies: const [],
                    tvShows: state.tvShows,
                    route: TvShowDetailPage.ROUTE_NAME,
                  );
                } else if (state is TvShowListErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              }),
              SubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvShowPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvShowBloc, TvShowListState>(
                  builder: (context, state) {
                if (state is TvShowListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvShowListState) {
                  return ItemList(
                    movies: [],
                    tvShows: state.tvShows,
                    route: TvShowDetailPage.ROUTE_NAME,
                  );
                } else if (state is TvShowListErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
