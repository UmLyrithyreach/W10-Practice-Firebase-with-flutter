import 'package:flutter/material.dart';

import '../../../../model/comment/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.comment),
      title: Text(comment.text),
      subtitle: Text(comment.createdAt.toLocal().toString()),
    );
  }
}
