import 'dart:ffi';

final String tableMovies = 'movies';

class MovieFields {
  static final List<String> values = [
    id, ref, nom, note, imageUrl, commentaire
  ];

  static final String id = '_id';
  static final String ref = 'ref';
  static final String nom = 'nom';
  static final String note = 'note';
  static final String imageUrl = 'imageUrl';
  static final String commentaire = 'commentaire';
}

class Movie {
  final int? id;
  final String ref;
  final String nom;
  final double note ;
  final String imageUrl;
  final String commentaire;

  const Movie({
    this.id,
    required this.ref,
    required this.nom,
    required this.note,
    required this.imageUrl,
    required this.commentaire,
  });

  Movie copy({
    int? id,
    String? ref,
    String? nom,
    double? note,
    String? imageUrl,
    String? commentaire,
  }) =>
      Movie(
        id: id ?? this.id,
        ref: ref ?? this.ref,
        nom: nom ?? this.nom,
        note: note ?? this.note,
        imageUrl: imageUrl ?? this.imageUrl,
        commentaire: commentaire ?? this.commentaire,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
        id: json[MovieFields.id] as int?,
        ref: json[MovieFields.ref] as String,
        nom: json[MovieFields.nom] as String,
        note: json[MovieFields.note] as double,
        imageUrl: json[MovieFields.imageUrl] as String,
        commentaire: json[MovieFields.commentaire] as String,
      );

  Map<String, Object?> toJson() => {
        MovieFields.id: id,
        MovieFields.ref: ref,
        MovieFields.nom: nom,
        MovieFields.note: note,
        MovieFields.imageUrl: imageUrl,
        MovieFields.commentaire: commentaire,
      };
}