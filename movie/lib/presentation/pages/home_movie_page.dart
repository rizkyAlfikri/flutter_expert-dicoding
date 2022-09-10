import 'package:core/core.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv_show/presentation/pages/home_tv_show_page.dart';
import 'package:tv_show/presentation/pages/watchlist_tv_show_page.dart';

import 'movie_detail_page.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeMoviePageState();
  }
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(const OnFetchNowPlayingMovies());
      context.read<PopularMovieBloc>().add(const OnFetchPopularMovies());
      context.read<TopRatedMovieBloc>().add(const OnFetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Tv Shows'),
              onTap: () {
                Navigator.pushNamed(context, HomeTvShowPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist Movie'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist Tv Show'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvShowPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE);
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
              BlocBuilder<NowPlayingMovieBloc, MovieListState>(
                  builder: (context, state) {
                if (state is MovieListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingMovieListState) {
                  return ItemList(
                    movies: state.movies,
                    tvShows: const [],
                    route: MovieDetailPage.ROUTE_NAME,
                  );
                } else if (state is MovieListErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              }),
              SubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularMovieBloc, MovieListState>(
                  builder: (context, state) {
                if (state is MovieListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PolularMovieListState) {
                  return ItemList(
                    movies: state.movies,
                    tvShows: const [],
                    route: MovieDetailPage.ROUTE_NAME,
                  );
                } else if (state is MovieListErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Failed');
                }
              }),
              SubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedMovieBloc, MovieListState>(
                  builder: (context, state) {
                if (state is MovieListLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedMovieListState) {
                  return ItemList(
                    movies: state.movies,
                    tvShows: const [],
                    route: MovieDetailPage.ROUTE_NAME,
                  );
                } else if (state is MovieListErrorState) {
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
