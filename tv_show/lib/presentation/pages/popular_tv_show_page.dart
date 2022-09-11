import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_show/presentation/bloc/tv_show_list/tv_show_list_bloc.dart';

import 'tv_show_detail_page.dart';

class PopularTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-show';
  const PopularTvShowPage({Key? key}) : super(key: key);

  @override
  State<PopularTvShowPage> createState() => _PopularTvShowPageState();
}

class _PopularTvShowPageState extends State<PopularTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularTvShowBloc>().add(const OnFetchPopularTvShows()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvShowBloc, TvShowListState>(
          builder: (context, state) {
            if (state is TvShowListLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PolularTvShowListState) {
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
                child: Text("Failed"),
              );
            }
          },
        ),
      ),
    );
  }
}
