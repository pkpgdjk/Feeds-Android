class Comment {
  final int id;
  final String content;
  final String author;
  final String symbol;
  final int date;

  Comment({this.id, this.content, this.author, this.symbol, this.date});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return new Comment(
        id: json['id'] as int,
        content: json['content'],
        author: json['author'],
        symbol: json['symbol'],
        date: json['date'] as int);
  }

  Map<String, dynamic> toJson() => {
        'id': id ?? "",
        'content': content,
        'author': author,
        'symbol': symbol ?? "",
        'date': date ?? "",
      };
}
