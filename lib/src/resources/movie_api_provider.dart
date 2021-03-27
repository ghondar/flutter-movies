import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;

import '../models/item_model.dart';
import '../models/trailer_model.dart';

class MovieApiProvider {
  Client client = Client();
  final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
  final _baseUrl = "http://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchMovieList(String type) async {
    Uri uri = Uri.parse("$_baseUrl/$type?api_key=$_apiKey");
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    Uri uri = Uri.parse("$_baseUrl/$movieId/videos?api_key=$_apiKey");
    final response =
        await client.get(uri);

    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
