import 'package:flutter/material.dart';
import '../model/movie_model.dart';

class AddEditMovie extends StatefulWidget {
  final Movie? movie;
  const AddEditMovie({super.key, this.movie});

  @override
  State<AddEditMovie> createState() => _AddEditMovieState();
}

class _AddEditMovieState extends State<AddEditMovie> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String image;

  @override
  void initState() {
    super.initState();
    title = widget.movie?.title ?? '';
    description = widget.movie?.description ?? '';
    image = widget.movie?.image ?? '';
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty && image.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: saveMovie,
        child: const Text('Save'),
      ),
    );
  }

  void saveMovie() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.movie != null;

      if (isUpdating) {
        await editMovie();
      } else {
        await addMovie();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await .update(note);
  }

  Future addNote() async {
    final movie = Movie(
      title: title,
      description: description,
      createdAt: DateTime.now().toIso8601String(),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formKey,
        child: MovieFormWidget(
          title: title,
          description: description,
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) => setState(() => this.description = description),
          onChangedImage: (image) => setState(() => this.image = image),
        ),
      ),
    );;
  }
}
