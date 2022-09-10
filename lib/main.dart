import 'package:about/about.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/http_ssl_pinning.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:search_movie/presentation/bloc/movie_search_bloc.dart';
import 'package:search_movie/presentation/pages/search_movie_page.dart';
import 'package:search_tv_show/presentation/bloc/tv_show_search_bloc.dart';
import 'package:search_tv_show/presentation/pages/search_tv_show_page.dart';
import 'package:tv_show/presentation/pages/home_tv_show_page.dart';
import 'package:tv_show/presentation/pages/popular_tv_show_page.dart';
import 'package:tv_show/presentation/pages/top_rated_tv_show_page.dart';
import 'package:tv_show/presentation/pages/tv_show_detail_page.dart';
import 'package:tv_show/presentation/pages/watchlist_tv_show_page.dart';
import 'package:tv_show/tv_show.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await HttpSSLPinning.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMovieBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMovieBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowSearchBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvShowBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvShowDetailWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvShowBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_ROUTE:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case ABOUT_ROUTE:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTvShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvShowPage());
            case PopularTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvShowPage());
            case TopRatedTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvShowPage());
            case TvShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvShowDetailPage(id: id),
                settings: settings,
              );
            case SearchTvShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvShowPage());
            case WatchlistTvShowPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvShowPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
