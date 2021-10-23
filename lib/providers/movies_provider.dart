import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/debouncer.dart';
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'd050821be756f20ee1a38bbdf1d0c212';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-PE';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  final Debouncer debouncer =
      Debouncer(duration: const Duration(milliseconds: 500));

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getResponseBody(String segment, [int page = 1]) async {
    final url = Uri.https(_baseUrl, segment, {
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

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    final jsonBody = (await http.get(url)).body;

    final SearchResponse searchResponse = SearchResponse.fromJson(jsonBody);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
