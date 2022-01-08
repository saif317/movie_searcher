import 'package:flutter/material.dart';
import 'package:movie_searcher/db/movie_db.dart';
import 'package:movie_searcher/models/movie.model.dart';
import 'package:rxdart/rxdart.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  FavouritesState createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  late List<Movie> filteredMovies;
  late List<Movie> movieCache;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    filteredMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    setupList();
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void setupList() async {
    MovieDB db = MovieDB();
    filteredMovies = await db.getMovies();
    // db.deleteDB();
    setState(() {
      movieCache = filteredMovies;
    });
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filteredMovies = movieCache;
      });
    }

    setState(() {});

    filteredMovies = filteredMovies
        .where((movie) => movie.title
            .toLowerCase()
            .trim()
            .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
        .toList();

    setState(() {});
  }

  void removeMovie(int index) async {
    MovieDB db = MovieDB();
    await db.removeMovie(filteredMovies[index].id);
    setState(() {
      filteredMovies.remove(filteredMovies[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(
            onChanged: (String string) => subject.add(string),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: filteredMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      removeMovie(index);
                    },
                  ),
                  title: SizedBox(
                    height: 200.0,
                    child: Row(
                      children: [
                        // ignore: unnecessary_null_comparison
                        filteredMovies[index].posterPath != null
                            ? Hero(
                                tag: filteredMovies[index].id,
                                child: Image.network(
                                    'https://image.tmdb.org/t/p/w92${filteredMovies[index].posterPath}'),
                              )
                            : Container(),
                        Expanded(
                          child: Text(
                            filteredMovies[index].title,
                            textAlign: TextAlign.center,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  initiallyExpanded: filteredMovies[index].isExpanded,
                  onExpansionChanged: (b) =>
                      filteredMovies[index].isExpanded = b,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
