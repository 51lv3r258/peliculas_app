import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'd050821be756f20ee1a38bbdf1d0c212';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-PE';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getResponseBody(String segment, [int page = 1]) async {
    var url = Uri.https(_baseUrl, segment, {
      'api_key': _apiKey,
      'language': _language,
      'page   ': '$page',
    });

    return (await http.get(url)).body;
  }

  getNowPlayingMovies() async {
    final String jsonBody = await _getResponseBody('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonBody);

    nowPlayingMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final String jsonBody =
        await _getResponseBody('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonBody);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final String jsonBody = await _getResponseBody('3/movie/$movieId/credits');

    final CreditsResponse creditsResponse = CreditsResponse.fromJson(jsonBody);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }
}
