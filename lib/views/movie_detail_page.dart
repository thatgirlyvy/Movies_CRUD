import 'package:flutter/material.dart';
import 'package:moviecrud/db/movie_database.dart';
import 'package:moviecrud/model/movie.dart';
import 'package:moviecrud/views/edit_movie_page.dart';

class MovieDetailPage extends StatefulWidget {

  final int movieId;

  const MovieDetailPage({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {

  late Movie movie;
  bool isLoading = false;

   @override
  void initState() {
    super.initState();

    refreshMovie();
  }

  Future refreshMovie() async {
    setState(() => isLoading = true);

    this.movie = await MoviesDatabase.instance.readMovie(widget.movieId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
     appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      movie.nom,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      movie.note.toString(),
                      style: TextStyle(color: Colors.white38),
                    ),
                    SizedBox(height: 8),
                    Text(
                      movie.commentaire,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
  );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditMoviePage(movie: movie),
        ));

        refreshMovie();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await MoviesDatabase.instance.delete(widget.movieId);

          Navigator.of(context).pop();
        },
      );
}