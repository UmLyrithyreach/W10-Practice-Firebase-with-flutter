import 'package:flutter/material.dart';

import '../../../../model/songs/song.dart';

class ArtistSongTile extends StatelessWidget {
  const ArtistSongTile({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(song.imageUrl.toString()),
      ),
      title: Text(song.title),
      subtitle: Text('${song.duration.inMinutes} mins'),
      trailing: Text('❤️ ${song.likes}'),
    );
  }
}
