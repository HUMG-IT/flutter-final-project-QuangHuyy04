class Book {
  final String id;
  final String title;
  final String author;
  final String status;
  final DateTime addedDate;
  final int? pageCount;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.addedDate,
    this.pageCount,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'author': author,
        'status': status,
        'addedDate': addedDate.toIso8601String(),
        'pageCount': pageCount,
      };

  factory Book.fromMap(Map<String, dynamic> map, String id) => Book(
        id: id,
        title: map['title'] ?? '',
        author: map['author'] ?? '',
        status: map['status'] ?? 'wantToRead',
        addedDate: DateTime.parse(map['addedDate'] ?? DateTime.now().toIso8601String()),
        pageCount: map['pageCount'],
      );
}