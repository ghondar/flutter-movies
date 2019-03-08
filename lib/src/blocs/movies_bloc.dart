import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

import '../models/item_model.dart';

class MoviesBloc {
  final _respository = Repository();
  final _type = PublishSubject<String>();
  final _movies = BehaviorSubject<Future<ItemModel>>();

  Function(String) get fetchAllMovies => _type.sink.add;

  Observable<Future<ItemModel>> get allMovies => _movies.stream;

  Observable<String> get type => _type.stream;

  MoviesBloc() {
    _type.stream.transform(_moviesTransformer()).pipe(_movies);
  }

  dispose() async {
    _type.close();
    await _movies.drain();
    _movies.close();
  }

  _moviesTransformer() {
    return ScanStreamTransformer(
        (Future<ItemModel> movies, String type, int index) {
      movies = _respository.fetchAllMovies(type);
      return movies;
    });
  }
}

final bloc = MoviesBloc();
