import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import 'movie_form_page.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieRepository _movieRepository = MovieRepository();
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final movies = await _movieRepository.getMovies();
    setState(() {
      _movies = movies;
      _filteredMovies = movies;
    });
  }

  void _addMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieFormPage()),
    ).then((result) {
      if (result == true) {
        _fetchMovies();
      }
    });
  }

  void _updateMovie(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieFormPage(movie: movie)),
    ).then((result) {
      if (result == true) {
        _fetchMovies();
      }
    });
  }

  void _deleteMovie(int id) async {
    await _movieRepository.deleteMovie(id);
    _fetchMovies();
  }

  void _readMovie(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailPage(movie: movie)),
    ).then((result) {
      if (result == true) {
        _fetchMovies();
      }
    });
  }

  void _searchMovies(String query) {
    setState(() {
      _searchQuery = query;
      _filteredMovies = _movies.where((movie) {
        final titleLower = movie.title.toLowerCase();
        final descriptionLower = movie.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: Text("Immanuel's Favorite Movies"),

      ),
      body: Column(
        children:
        [
          Row(
            children:
            [
              ElevatedButton(
                onPressed: _addMovie,
                child: Text('Add Movie'),
              ),
              Expanded(
                child:
                TextField(
                  decoration:
                  InputDecoration(
                    hintText: 'Search',
                  ),
                  onChanged: _searchMovies,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // The search is already handled by the onChanged callback.
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                final movie = _filteredMovies[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: ClipRRect(
                      child: Image
                          .network(
                        movie
                            .picture,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(movie.title),
                    subtitle: Text(movie.description),
                    onTap: () => _readMovie(movie),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                      [
                        IconButton(
                          icon: Icon(Icons.read_more),
                          onPressed: () => _readMovie(movie),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _updateMovie(movie),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteMovie(movie.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}