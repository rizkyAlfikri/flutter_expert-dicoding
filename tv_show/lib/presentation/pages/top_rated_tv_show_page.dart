import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_show/presentation/bloc/tv_show_list/tv_show_list_bloc.dart';
import 'package:tv_show/presentation/pages/tv_show_detail_page.dart';

class TopRatedTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-show';
  const TopRatedTvShowPage({Key? key}) : super(key: key);

  @override
  State<TopRatedTvShowPage> createState() => _TopRatedTvShowPageState();
}

class _TopRatedTvShowPageState extends State<TopRatedTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TopRatedTvShowBloc>().add(const OnFetchTopRatedTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvShowListState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvShow = state.tvShows[index];
                  return ItemCard(
                    movie: null,
                    tvShow: tvShow,
                    route: TvShowDetailPage.ROUTE_NAME,
                  );
                },
                itemCount: state.tvShows.length,
              );
            } else if (state is TvShowListErrorState) {
              CrashlyticTracker.recordCrashEvent(state.message);
              return Text(state.message);
            } else {
              return const Center(
                child: Text('Failed'),
              );
            }
          },
        ),
      ),
    );
  }
}
