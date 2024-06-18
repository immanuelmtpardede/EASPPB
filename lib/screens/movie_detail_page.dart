import 'package:flutter/material.dart';
import 'movie_form_page.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  MovieDetailPage({required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieRepository _movieRepository = MovieRepository();

  void _editMovie() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieFormPage(movie: widget.movie)),
    );

    if (result == true) {
      setState(() {
        Navigator.pop(context, true);
      });
    }
  }

  void _deleteMovie() async {
    await _movieRepository.deleteMovie(widget.movie.id!);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editMovie,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteMovie,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.movie.picture,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.movie.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.movie.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Created at: ${widget.movie.createdAt.toLocal()}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}