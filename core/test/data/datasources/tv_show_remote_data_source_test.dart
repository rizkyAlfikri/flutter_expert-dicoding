import 'dart:convert';

import 'package:core/data/datasources/tv_show_remote_data_source.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:core/data/models/tv_show_detail_model.dart';
import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvShowRemoteDataSourceImpl dataSource;
  late MockIOClient client;

  setUp(() {
    client = MockIOClient();
    dataSource = TvShowRemoteDataSourceImpl(client: client);
  });

  group('get Now Playing Tv Shows', () {
    final tTvShowList = TvShowResponse.fromMap(
            json.decode(readJson('dummy_data/now_playing.json')))
        .results;

    test('should return list of Tv Show Model when the response code is 200',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/now_playing.json'), 200));
      // act
      final result = await dataSource.getNowPlayingTvShows();
      // assert
      expect(result, equals(tTvShowList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv Show', () {
    final tTvShowList =
        TvShowResponse.fromMap(json.decode(readJson('dummy_data/popular.json')))
            .results;

    test('should return list of tv show when response is success (200)',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'))).thenAnswer(
          (_) async => http.Response(readJson('dummy_data/popular.json'), 200));
      // act
      final result = await dataSource.getPopularTvShows();
      // assert
      expect(result, tTvShowList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Tv Show', () {
    final tTvShowList = TvShowResponse.fromMap(
            json.decode(readJson('dummy_data/top_rated.json')))
        .results;

    test('should return list of tv show when response code is 200 ', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'))).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvShows();
      // assert
      expect(result, tTvShowList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTvShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show detail', () {
    final tId = 1;
    final tTvShowDetail = TvShowDetailResponse.fromMap(
        json.decode(readJson('dummy_data/movie_detail.json')));

    test('should return tv show detail when the response code is 200',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY'))).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/movie_detail.json'), 200));
      // act
      final result = await dataSource.getTvShowDetail(tId);
      // assert
      expect(result, equals(tTvShowDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv show recommendations', () {
    final tTvShowList = TvShowResponse.fromMap(
            json.decode(readJson('dummy_data/movie_recommendations.json')))
        .results;
    final tId = 1;

    test('should return list of Tv Show Model when the response code is 200',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie_recommendations.json'), 200));
      // act
      final result = await dataSource.getTvShowRecomendations(tId);
      // assert
      expect(result, equals(tTvShowList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvShowRecomendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv show', () {
    final tSearchResult = TvShowResponse.fromMap(
            json.decode(readJson('dummy_data/search_spiderman_movie.json')))
        .results;
    final tQuery = 'Spiderman';

    test('should return list of tv show when response code is 200', () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_spiderman_movie.json'), 200));
      // act
      final result = await dataSource.searchTvShows(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvShows(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
