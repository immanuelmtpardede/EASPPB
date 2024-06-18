class Movie {
  int? id;
  String title;
  DateTime createdAt;
  String picture;
  String description;

  Movie({
    this.id,
    required this.title,
    required this.createdAt,
    required this.picture,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'picture': picture,
      'description': description,
    };
  }

  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['created_at']),
      picture: map['picture'],
      description: map['description'],
    );
  }
}