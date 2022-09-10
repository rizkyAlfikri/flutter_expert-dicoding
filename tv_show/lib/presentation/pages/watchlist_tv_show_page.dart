import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_show/presentation/pages/tv_show_detail_page.dart';
import 'package:tv_show/tv_show.dart';

class WatchlistTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv-show';
  const WatchlistTvShowPage({Key? key}) : super(key: key);

  @override
  State<WatchlistTvShowPage> createState() => _WatchlistTvShowPageState();
}

class _WatchlistTvShowPageState extends State<WatchlistTvShowPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context
        .read<WatchlistTvShowBloc>()
        .add(const OnFetchWatchlistTvShowsEvent()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context
        .read<WatchlistTvShowBloc>()
        .add(const OnFetchWatchlistTvShowsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Tv Shows'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvShowBloc, WatchlistTvShowState>(
          builder: (context, state) {
            if (state is WatchlistTvShowLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvShowsSuccessState) {
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
            } else if (state is WatchlistTvShowErrorState) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
