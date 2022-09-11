import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticTracker {
  static late FirebaseAnalytics _analytics;

  static void init() {
    _analytics = FirebaseAnalytics.instance;
  }

  static Future<void> sendMovieFavoriteAnalyticsEvent(
      MovieDetail movie, bool isFavorite) async {
    _analytics.logEvent(
      name: 'Movie_Favorite_event',
      parameters: <String, dynamic>{
        'id': movie.id,
        'title': movie.title,
        'isFavorite': isFavorite
      },
    );
  }

  static Future<void> sendTvFavoriteAnalyticsEvent(
      TvShowDetail tv, bool isFavorite) async {
    _analytics.logEvent(
      name: 'Tv_Favorite_event',
      parameters: <String, dynamic>{
        'id': tv.id,
        'title': tv.name,
        'isFavorite': isFavorite
      },
    );
  }
}
