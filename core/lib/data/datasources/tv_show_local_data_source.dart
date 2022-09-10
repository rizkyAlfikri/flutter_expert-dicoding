import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/models/tv_show_table.dart';
import 'package:core/utils/exception.dart';

abstract class TvShowLocalDataSource {
  Future<String> insertWatchlist(TvShowTable tvShowTable);
  Future<String> removeWatchlist(TvShowTable tvShowTable);
  Future<TvShowTable?> getTvShowById(int id);
  Future<List<TvShowTable>> getWatchlistTvShows();
}

class TvShowLocalDataSourceImpl implements TvShowLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvShowLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<TvShowTable?> getTvShowById(int id) async {
    final result = await databaseHelper.getTvShowById(id);
    if (result != null) {
      return TvShowTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvShowTable>> getWatchlistTvShows() async {
    final result = await databaseHelper.getWatchlistTvShow();
    return result.map((data) => TvShowTable.fromMap(data)).toList();
  }

  @override
  Future<String> insertWatchlist(TvShowTable tvShowTable) async {
    try {
      await databaseHelper.insertTvWatchlist(tvShowTable);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvShowTable tvShowTable) async {
    try {
      await databaseHelper.removeTvWatchlist(tvShowTable);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
