import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static const String _host =
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri songsUri = Uri.https(
    _host,
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<Song> likeSong(Song song) async {
    final int newLikes = song.likes + 1;

    final Uri likesUri = Uri.https(_host, '/songs/${song.id}/likes.json');
    final http.Response response = await http.put(
      likesUri,
      body: jsonEncode(newLikes),
    );

    if (response.statusCode == 200) {
      return Song(
        id: song.id,
        title: song.title,
        artistId: song.artistId,
        duration: song.duration,
        imageUrl: song.imageUrl,
        likes: newLikes,
      );
    } else {
      throw Exception('Failed to like song');
    }
  }
}
