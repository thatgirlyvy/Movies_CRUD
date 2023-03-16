import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MovieFormWidget extends StatefulWidget {
  final String? ref;
  final String? nom;
  final double? note;
  final String? imageUrl;
  final String? commentaire;
  final ValueChanged<String> onChangedNom;
  final ValueChanged<double> onChangedNote;
  final ValueChanged<String> onChangedImage;
  final ValueChanged<String> onChangedCommentaire;

  const MovieFormWidget({
    Key? key,
    this.ref = '',
    this.nom = '',
    this.note = 0.0,
    this.imageUrl = '',
    this.commentaire = '',
    required this.onChangedNom,
    required this.onChangedNote,
    required this.onChangedImage,
    required this.onChangedCommentaire,
  }) : super(key: key);

  @override
  State<MovieFormWidget> createState() => _MovieFormWidgetState();
}

class _MovieFormWidgetState extends State<MovieFormWidget> {

  XFile? image;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context)=> SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildImage(),
              SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: (widget.note ?? 0).toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      onChanged: (number) => widget.onChangedNote(number),
                    ),
                  )
                ],
              ),
              buildNom(),
              SizedBox(height: 8),
              buildCommentaire(),
              SizedBox(height: 16),
            ],
          ),
        ),
  );

  Widget buildNom() => TextFormField(
        maxLines: 1,
        initialValue: widget.nom,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The name cannot be empty' : null,
        onChanged: widget.onChangedNom,
      );

  Widget buildCommentaire() => TextFormField(
        maxLines: 5,
        initialValue: widget.commentaire,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The comment cannot be empty'
            : null,
        onChanged: widget.onChangedCommentaire,
      );

  Widget buildImage() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ElevatedButton(
        child: Text('choose an image'),
        onPressed: () {
          myAlert();
        },
      ),
      SizedBox(
              height: 10,
            ),
            //if image not null show the image
            //if image null show text
            image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        File(image!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                : Text(
                    "No Image",
                    style: TextStyle(fontSize: 20),
                  )
    ],
  );

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}