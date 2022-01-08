import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_searcher/db/movie_db.dart';
import 'package:rxdart/rxdart.dart';

import 'package:movie_searcher/models/movie.model.dart';
import 'package:movie_searcher/views/home_page/widgets/movie_view.widget.dart';

class HomePage extends StatefulWidget {
  final String apiKey;

  const HomePage(this.apiKey, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  late List<Movie> favoritedMovies;
  bool hasLoaded = true;

  final PublishSubject subject = PublishSubject();

  @override
  void initState() {
    super.initState();
    subject.stream
        .debounceTime(const Duration(milliseconds: 400))
        .listen(searchMovies);
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void resetMovies() {
    setState(() {
      movies.clear();
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void addMovie(item) async {
    setState(() {
      movies.add(Movie.fromJson(item));
    });
  }

  void searchMovies(query) {
    resetMovies();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
    }
    setState(() {
      hasLoaded = false;
    });

    http
        .get(Uri.parse(
            'https://api.themoviedb.org/3/search/movie?api_key=${widget.apiKey}&query=$query'))
        .then((res) => res.body)
        .then(json.decode)
        .then((map) => map['results'])
        .then((movies) => movies.forEach(addMovie))
        .catchError(onError)
        .then((e) {
      setState(() {
        hasLoaded = true;
      });
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
          ),
          hasLoaded ? Container() : const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return MovieView(
                  movie: movies[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
