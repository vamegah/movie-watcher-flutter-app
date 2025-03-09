import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'models/movie.dart';
import 'auth_service.dart';
import 'add_movie_screen.dart';
import 'modify_movie_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthService authService = AuthService();

  final TextEditingController _commentController = TextEditingController();

  Future<List<Movie>> _fetchMovies() async {
    QuerySnapshot snapshot = await firestore.collection('movies').get();
    return snapshot.docs.map((doc) {
      return Movie.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> _addComment(String movieId) async {
    if (_commentController.text.isNotEmpty) {
      await firestore.collection('movies').doc(movieId).collection('comments').add({
        'comment': _commentController.text,
        'userId': authService.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _commentController.clear(); // Clear the comment input
    }
  }

  Future<void> _deleteMovie(String movieId) async {
    try {
      await firestore.collection('movies').doc(movieId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie deleted successfully')),
      );
      setState(() {}); // Refresh the UI
    } catch (e) {
      print("Error deleting movie: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete movie')),
      );
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Watcher'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching movies'));
          }

          final movies = snapshot.data!;
          if (movies.isEmpty) {
            return Center(child: Text('No movies found.'));
          }

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Card(
                child: Column(
                  children: [
                    Image.network(movie.imageUrl, height: 250, fit: BoxFit.cover),
                    ListTile(
                      title: Text(movie.title),
                      subtitle: Text('${movie.genre}\n${movie.description}'),
                    ),
                    // Display YouTube Video URL as a clickable text
                    if (movie.videoUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Text(
                            'Video URL: ${movie.videoUrl}',
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                          onTap: () => _launchURL(movie.videoUrl),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(labelText: 'Add a comment'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _addComment(movie.id),
                      child: Text('Submit Comment'),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('movies').doc(movie.id).collection('comments').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return CircularProgressIndicator();
                        final comments = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, commentIndex) {
                            var commentData = comments[commentIndex].data() as Map<String, dynamic>;
                            return ListTile(
                              title: Text(commentData['comment']),
                              //subtitle: Text('User ID: ${commentData['userId']}'),
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModifyMovieScreen(movieId: movie.id),
                              ),
                            );
                          },
                          child: Text('Modify Movie', style: TextStyle(color: Colors.blue)),
                        ),
                        SizedBox(width: 16), // Spacing between buttons
                        TextButton(
                          onPressed: () => _deleteMovie(movie.id), // Call delete function
                          child: Text('Delete Movie', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMovieScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Movie',
      ),
    );
  }
}