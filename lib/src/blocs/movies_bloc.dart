import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';

import '../models/item_model.dart';

class TypeMovie {
  String type;
  String name;

  TypeMovie(this.type, this.name);
}

class MoviesBloc {
  final _respository = Repository();
  final _type = BehaviorSubject<TypeMovie>();
  final _movies = BehaviorSubject<Future<ItemModel>>();

  Function(TypeMovie) get fetchAllMovies => _type.sink.add;

  ValueStream<Future<ItemModel>> get allMovies => _movies.stream;

  ValueStream<TypeMovie> get type => _type.stream;

  MoviesBloc() {
    _type.stream.transform(_moviesTransformer()).pipe(_movies);
  }

  dispose() async {
    _type.close();
    await _movies.drain();
    _movies.close();
  }

  ScanStreamTransformer<TypeMovie, Future<ItemModel>> _moviesTransformer() {
    return ScanStreamTransformer(
        (Future<ItemModel>? movies, TypeMovie typeMovie, int index) {
      movies = _respository.fetchAllMovies(typeMovie.type);
      return movies;
    });
  }
}

final MoviesBloc bloc = new MoviesBloc();
