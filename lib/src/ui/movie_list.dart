import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';
import 'movie_detail.dart';
import '../blocs/movie_detail_bloc_provider.dart';

class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  void initState() {
    super.initState();
    TypeMovie typeMovie = TypeMovie('now_playing', 'Ultimos');
    bloc.fetchAllMovies(typeMovie);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.type,
      builder: (context, AsyncSnapshot<TypeMovie> typeSnapshot) {
        print(typeSnapshot);
        return Scaffold(
          appBar: AppBar(
            title:
                Text(typeSnapshot.hasData ? typeSnapshot.data.name : 'Title'),
          ),
          body: StreamBuilder(
            stream: bloc.allMovies,
            builder: (context, AsyncSnapshot<Future<ItemModel>> snapshot) {
              return FutureBuilder(
                  future: snapshot.data,
                  builder: (context, AsyncSnapshot<ItemModel> movieSnapShot) {
                    if (movieSnapShot.hasData) {
                      return buildList(movieSnapShot);
                    } else if (movieSnapShot.hasError) {
                      return Text(movieSnapShot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  });
            },
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Ultimos"),
                  selected: !typeSnapshot.hasData ||
                      typeSnapshot.data.type == 'now_playing',
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => onChangeTypeMovie('now_playing', 'Ultimos'),
                ),
                ListTile(
                  title: Text("Populares"),
                  trailing: Icon(Icons.arrow_forward),
                  selected: !typeSnapshot.hasData ||
                      typeSnapshot.data.type == 'popular',
                  onTap: () => onChangeTypeMovie('popular', 'Populares'),
                ),
                ListTile(
                  title: Text("Mas Votados"),
                  trailing: Icon(Icons.arrow_forward),
                  selected: !typeSnapshot.hasData ||
                      typeSnapshot.data.type == 'top_rated',
                  onTap: () => onChangeTypeMovie('top_rated', 'Mas Votados'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.results.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(5.0),
          child: GridTile(
              child: InkResponse(
                  enableFeedback: true,
                  child: Image.network(
                      "https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}",
                      fit: BoxFit.cover),
                  onTap: () => openDetailPage(snapshot.data, index))),
        );
      },
    );
  }

  onChangeTypeMovie(String type, String name) {
    Navigator.of(context).pop();
    TypeMovie typeMovie = TypeMovie(type, name);
    bloc.fetchAllMovies(typeMovie);
  }

  openDetailPage(ItemModel data, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieDetailBlocProvider(
          child: MovieDetail(
        title: data.results[index].title,
        posterUrl: data.results[index].backdrop_path,
        description: data.results[index].overview,
        releaseDate: data.results[index].release_date,
        voteAverage: data.results[index].vote_average.toString(),
        movieId: data.results[index].id,
      ));
    }));
  }
}
