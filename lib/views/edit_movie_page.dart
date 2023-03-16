import 'package:flutter/material.dart';
import 'package:moviecrud/db/movie_database.dart';
import 'package:moviecrud/model/movie.dart';
import 'package:moviecrud/widget/movie_form_widget.dart';

class AddEditMoviePage extends StatefulWidget {
  final Movie? movie;

  const AddEditMoviePage({
    Key? key,
    this.movie,
  }) : super(key: key);

  @override
  State<AddEditMoviePage> createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {

  final _formKey = GlobalKey<FormState>();
  late String ref;
  late String nom;
  late double note;
  late String imageUrl;
  late String commentaire;

  
  @override
  void initState() {
    super.initState();

    ref = widget.movie?.ref ?? '';
    nom = widget.movie?.nom ?? '';
    note = widget.movie?.note ?? 0.0;
    imageUrl = widget.movie?.imageUrl ?? '';
    commentaire = widget.movie?.commentaire ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: MovieFormWidget(
            ref: ref,
            nom: nom,
            note: note,
            imageUrl: imageUrl,
            commentaire: commentaire,
            onChangedNom: (nom) => setState(() => this.nom = nom),
            onChangedNote: (note) => setState(() => this.note = note),
            onChangedImage: (imageUrl) =>
                setState(() => this.imageUrl = imageUrl),
                onChangedCommentaire: (commentaire) => setState(() => this.commentaire = commentaire),
          ),
        ),
  );

  Widget buildButton() {
    final isFormValid = nom.isNotEmpty && imageUrl.isNotEmpty && commentaire.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMovie,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateMovie() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.movie != null;

      if (isUpdating) {
        await updateMovie();
      } else {
        await addMovie();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateMovie() async {
    final movie = widget.movie!.copy(
      ref: ref,
      nom: nom,
      note: note,
      imageUrl: imageUrl,
      commentaire: commentaire,
    );

    await MoviesDatabase.instance.update(movie);
  }

  Future addMovie() async {
    final movie = Movie(
      ref: ref,
      nom: nom,
      note: note,
      imageUrl: imageUrl,
      commentaire: commentaire,
    );

    await MoviesDatabase.instance.create(movie);
  }
}