import 'package:flutter/material.dart';

import 'package:movie_searcher/models/movie.model.dart';

class MovieView extends StatefulWidget {
  const MovieView({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  late Movie movieState;

  @override
  void initState() {
    super.initState();
    movieState = widget.movie;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: IconButton(
        icon: movieState.favored!
            ? const Icon(Icons.star)
            : const Icon(Icons.star_border),
        color: Colors.white,
        onPressed: () {},
      ),
      title: Container(
        height: 200.0,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // ignore: unnecessary_null_comparison
            movieState.posterPath != null
                ? Hero(
                    tag: movieState.id,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w92${movieState.posterPath}',
                    ),
                  )
                : Container(),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          movieState.title,
                          maxLines: 10,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      children: [
        Container(
          child: RichText(text: TextSpan(text: movieState.overview)),
        )
      ],
    );
  }
}
