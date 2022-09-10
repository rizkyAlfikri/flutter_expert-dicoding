import 'dart:io';

import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_show_local_data_source.dart';
import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_show_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_show_repository.dart';
import 'package:core/utils/http_ssl_pinning.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:search_movie/presentation/bloc/movie_search_bloc.dart';
import 'package:search_movie/search_movie.dart';
import 'package:search_tv_show/domain/usecases/search_tv_shows.dart';
import 'package:search_tv_show/presentation/bloc/tv_show_search_bloc.dart';
import 'package:tv_show/domain/usecases/get_now_paling__tv_shows.dart';
import 'package:tv_show/domain/usecases/get_populart_tv_shows.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:tv_show/domain/usecases/get_tv_show_detail.dart';
import 'package:tv_show/domain/usecases/get_tv_show_recomendations.dart';
import 'package:tv_show/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv_show/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:tv_show/domain/usecases/remove_tv_watchlist.dart';
import 'package:tv_show/domain/usecases/save_tv_watchlist.dart';
import 'package:tv_show/tv_show.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => NowPlayingMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => PopularMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TopRatedMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => MovieSearchBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => MovieDetailBloc(
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => MovieDetailWatchlistBloc(
      locator(),
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistMovieBloc(
      locator(),
    ),
  );

  // tv show bloc
  locator.registerFactory(
    () => NowPlayingTvShowBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => PopularTvShowBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TopRatedTvShowBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TvShowSearchBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TvShowDetailBloc(
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => TvShowDetailWatchlistBloc(
      locator(),
      locator(),
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistTvShowBloc(
      locator(),
    ),
  );

  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case tvshow
  locator.registerLazySingleton(() => GetNowPlayingTvShows(locator()));
  locator.registerLazySingleton(() => GetPopularTvShows(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvShows(locator()));
  locator.registerLazySingleton(() => GetTvShowDetail(locator()));
  locator.registerLazySingleton(() => GetTvShowRecomendations(locator()));
  locator.registerLazySingleton(() => SearchTvShows(locator()));
  locator.registerLazySingleton(() => GetTvWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvShows(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvShowRepository>(
    () => TvShowRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvShowRemoteDataSource>(
      () => TvShowRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvShowLocalDataSource>(
      () => TvShowLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}

Future<IOClient> get getClient async {
  final sslCert = await rootBundle.load('assets/themoviedb.org.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  HttpClient client = HttpClient(context: securityContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;

  return IOClient(client);
}
