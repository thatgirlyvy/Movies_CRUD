import 'package:moviecrud/db/movie_database.dart';
import 'package:moviecrud/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:moviecrud/views/edit_movie_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moviecrud/views/movie_detail_page.dart';
import 'package:moviecrud/widget/movie_card_widget.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  late List<Movie> movies;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshMovies();
  }

  @override
  void dispose() {
    MoviesDatabase.instance.close();

    super.dispose();
  }

  Future refreshMovies() async {
    setState(() => isLoading = true);

    this.movies = await MoviesDatabase.instance.readAllMovies();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Movies',
            style: TextStyle(fontSize: 24),
          ),
          actions: [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : movies.isEmpty
                  ? Text(
                      'No Movies',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildMovies(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditMoviePage()),
            );

            refreshMovies();
          },
        ),
      );

  Widget buildMovies() => MasonryGridView.count(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MovieDetailPage(movieId: movie.id!),
              ));

              refreshMovies();
            },
            child: MovieCardWidget(movie: movie, index: index),
          );
        },
      );
}