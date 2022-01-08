import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_searcher/views/favorites.view.dart';
import 'package:movie_searcher/views/home_page/home_page.view.dart';

final key = dotenv.env['KEY'];

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movieous',
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Movious'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home Page',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Favourites',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomePage(key!),
              const Favourites(),
            ],
          ),
        ),
      ),
    );
  }
}
