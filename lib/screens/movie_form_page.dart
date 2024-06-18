import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

class MovieFormPage extends StatefulWidget {
  final Movie? movie;

  MovieFormPage({this.movie});

  @override
  _MovieFormPageState createState() => _MovieFormPageState();
}

class _MovieFormPageState extends State<MovieFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _pictureController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _pictureController.text = widget.movie!.picture;
      _descriptionController.text = widget.movie!.description;
      _createdAt = widget.movie!.createdAt;
    } else {
      _createdAt = DateTime.now();
    }
  }

  void _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: widget.movie?.id,
        title: _titleController.text,
        createdAt: _createdAt,
        picture: _pictureController.text,
        description: _descriptionController.text,
      );

      final movieRepository = MovieRepository();
      if (widget.movie == null) {
        await movieRepository.insertMovie(movie);
      } else {
        await movieRepository.updateMovie(movie);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pictureController,
                decoration: InputDecoration(labelText: 'Picture URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a picture URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveMovie,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}