import 'dart:convert';

import 'package:core/data/models/tv_response.dart';
import 'package:core/data/models/tv_show_detail_model.dart';
import 'package:core/data/models/tv_show_model.dart';
import 'package:core/utils/exception.dart';
import 'package:http/io_client.dart';

abstract class TvShowRemoteDataSource {
  Future<List<TvShowModel>> getNowPlayingTvShows();
  Future<List<TvShowModel>> getPopularTvShows();
  Future<List<TvShowModel>> getTopRatedTvShows();
  Future<TvShowDetailResponse> getTvShowDetail(int id);
  Future<List<TvShowModel>> getTvShowRecomendations(int id);
  Future<List<TvShowModel>> searchTvShows(String query);
}

class TvShowRemoteDataSourceImpl implements TvShowRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final IOClient client;

  TvShowRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvShowModel>> getNowPlayingTvShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getPopularTvShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTopRatedTvShows() async {
    final response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvShowDetailResponse> getTvShowDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowDetailResponse.fromMap(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> searchTvShows(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvShowModel>> getTvShowRecomendations(int id) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvShowResponse.fromMap(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }
}
