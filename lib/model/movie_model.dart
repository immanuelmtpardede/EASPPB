class Movie {
  final int id;
  final String title;
  final String createdAt;
  final String description;
  final String image;

  Movie({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.description,
    required this.image,
  });

  factory Movie.fromSqfliteDatabase(Map<String, dynamic> map) => Movie(
    id: map['id']?.toInt() ?? 0,
    title: map['title'] ?? '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    description: map['description'] ?? '',
    image: map['image'] ?? '',
  );
}