import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/movie.dart';

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController(); // New controller for video URL

  Future<void> _addMovie() async {
    if (_titleController.text.isNotEmpty &&
        _genreController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _imageUrlController.text.isNotEmpty &&
        _videoUrlController.text.isNotEmpty) { // Check for video URL

      Movie movie = Movie(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        genre: _genreController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        videoUrl: _videoUrlController.text.trim(), // Set video URL
      );

      await FirebaseFirestore.instance.collection('movies').doc(movie.id).set(movie.toMap());
      Navigator.pop(context); // Go back after adding a movie
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _genreController,
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _videoUrlController, // New field for video URL
              decoration: InputDecoration(labelText: 'YouTube Video URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addMovie, child: Text('Add Movie')),
          ],
        ),
      ),
    );
  }
}