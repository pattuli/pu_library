class Users {
  String uid;
  final String email;
  late int booked_books;
  Users({
    required this.uid,
    required this.email,
    required this.booked_books,
  });
  static Users fromJson(Map<String, dynamic> json) => Users(
        uid: json['id'],
        email: json['email'],
        booked_books: json['booked_books'],
      );
}
