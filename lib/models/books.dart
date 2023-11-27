class Books {
  String id;
  final String name;
  // Timestamp pubdate;
  final String imageurl;
  final String category;
  final String author;

  Books({
    required this.id,
    required this.name,
    // required this.pubdate,
    required this.imageurl,
    required this.category,
    required this.author,
  });
  static Books fromJson(Map<String, dynamic> json) => Books(
        id: json['id'],
        name: json['name'],
        // pubdate: (json['pubdate']),
        imageurl: json['image'],
        category: json['category'],
        author: json['author'],
      );
}
