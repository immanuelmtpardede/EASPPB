import 'package:flutter/material.dart';
import '../controller/add_edit_movie.dart';
import '../database/movie_db.dart';
import '../model/movie_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final movie_db = MovieDB();
  late List<Movie> movies;

  Future refreshNotes() async {
    movies = await movie_db.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Koleksi Film Kesukaanku'),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditMovie()),
          );
          refreshNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}