import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PopularMoviesPageState();
  }
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<PopularMovieBloc>().add(const OnFetchPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PolularMovieListState) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return ItemCard(
                    movie: movie,
                    tvShow: null,
                    route: MovieDetailPage.ROUTE_NAME,
                  );
                },
                itemCount: state.movies.length,
              );
            } else if (state is MovieListErrorState) {
              CrashlyticTracker.recordCrashEvent(state.message);
              return Center(
                child: Text(state.message),
              );
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
