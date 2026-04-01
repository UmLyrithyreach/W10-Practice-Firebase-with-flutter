import '../../model/comment/comment.dart';

class CommentDto {
  static const String textKey = 'text';
  static const String createdAtKey = 'createdAt';

  static Comment fromJson(
    String id,
    String artistId,
    Map<String, dynamic> json,
  ) {
    return Comment(
      id: id,
      artistId: artistId,
      text: (json[textKey] as String?) ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json[createdAtKey].toString()) ?? 0,
      ),
    );
  }

  static Map<String, dynamic> toJsonForCreate(String text, DateTime createdAt) {
    return {textKey: text, createdAtKey: createdAt.millisecondsSinceEpoch};
  }
}
