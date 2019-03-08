import 'dart:async';
import 'movie_api_provider.dart';

import '../models/item_model.dart';
import '../models/trailer_model.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies(String type) =>
      moviesApiProvider.fetchMovieList(type);

  Future<TrailerModel> fetchTrailers(int movieId) =>
      moviesApiProvider.fetchTrailer(movieId);
}
