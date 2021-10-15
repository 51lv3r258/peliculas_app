import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'd050821be756f20ee1a38bbdf1d0c212';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-PE';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  MoviesProvider() {
    // ignore: avoid_print
    print('Movies Provider inicializado');

    getNowPlayingMovies();
    getPopularMovies();
  }

  getNowPlayingMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page   ': '1',
    });

    final response = await http.get(url);

    // final Map<String, dynamic> data = json.decode(response.body);
    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);

    nowPlayingMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page   ': '1',
    });

    final response = await http.get(url);

    final popularResponse = PopularResponse.fromJson(response.body);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }
}
