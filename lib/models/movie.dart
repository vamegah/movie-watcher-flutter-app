class Movie {
  String id;
  String title;
  String genre;
  String description;
  String imageUrl;
  String videoUrl; // New field for video URL

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.imageUrl,
    required this.videoUrl, // Include in constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl, // Include in map
    };
  }

  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'], // Include in fromMap
    );
  }
}