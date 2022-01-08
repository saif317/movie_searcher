class Movie {
  String title, posterPath, id, overview;
  bool favored, isExpanded;

  Movie(
      {required this.title,
      required this.posterPath,
      required this.id,
      required this.overview,
      required this.favored,
      required this.isExpanded});

  Movie.fromJson(Map json)
      : title = json['title'],
        posterPath = json['poster_path'],
        id = json['id'].toString(),
        overview = json['overview'],
        favored = false,
        isExpanded = false;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['poster_path'] = posterPath;
    map['overview'] = overview;
    map['favored'] = favored;
    return map;
  }

  Movie.fromDB(Map map)
      : title = map['title'],
        posterPath = map['poster_path'],
        id = map['id'].toString(),
        overview = map['overview'],
        favored = map['favored'] == 1 ? true : false,
        isExpanded = false;
}
