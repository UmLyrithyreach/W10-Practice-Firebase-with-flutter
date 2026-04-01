import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import '../../dtos/song_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static const String _host =
      'test-a2a77-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri artistsUri = Uri.https(_host, '/artists.json');

  List<Artist>? _cachedArtists;
  final Map<String, List<Song>> _cachedSongsByArtistId = {};
  final Map<String, List<Comment>> _cachedCommentsByArtistId = {};

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in songJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }
      _cachedArtists = result;
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {}

  @override
  Future<List<Song>> fetchSongsByArtistId(
    String artistId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedSongsByArtistId[artistId] != null) {
      return _cachedSongsByArtistId[artistId]!;
    }

    final Uri songsUri = Uri.https(_host, '/songs.json');
    final http.Response response = await http.get(songsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load songs');
    }

    final Map<String, dynamic> songJson =
        (json.decode(response.body) as Map?)?.cast<String, dynamic>() ?? {};

    final List<Song> songs = [];
    for (final entry in songJson.entries) {
      final Map<String, dynamic>? value = (entry.value as Map?)
          ?.cast<String, dynamic>();
      if (value == null) continue;

      if (value[SongDto.artistIdKey] == artistId) {
        songs.add(SongDto.fromJson(entry.key, value));
      }
    }

    _cachedSongsByArtistId[artistId] = songs;
    return songs;
  }

  @override
  Future<List<Comment>> fetchCommentsByArtistId(
    String artistId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedCommentsByArtistId[artistId] != null) {
      return _cachedCommentsByArtistId[artistId]!;
    }

    final Uri commentsUri = Uri.https(_host, '/comments/$artistId.json');
    final http.Response response = await http.get(commentsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load comments');
    }

    if (response.body == 'null') {
      _cachedCommentsByArtistId[artistId] = [];
      return [];
    }

    final Map<String, dynamic> commentsJson =
        (json.decode(response.body) as Map?)?.cast<String, dynamic>() ?? {};

    final List<Comment> comments = commentsJson.entries
        .map((entry) {
          final Map<String, dynamic>? value = (entry.value as Map?)
              ?.cast<String, dynamic>();
          if (value == null) return null;
          return CommentDto.fromJson(entry.key, artistId, value);
        })
        .whereType<Comment>()
        .toList();

    comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _cachedCommentsByArtistId[artistId] = comments;
    return comments;
  }

  @override
  Future<Comment> addComment({
    required String artistId,
    required String text,
  }) async {
    final DateTime now = DateTime.now();
    final Uri commentsUri = Uri.https(_host, '/comments/$artistId.json');
    final http.Response response = await http.post(
      commentsUri,
      body: jsonEncode(CommentDto.toJsonForCreate(text, now)),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }

    final Map<String, dynamic> responseJson =
        (json.decode(response.body) as Map?)?.cast<String, dynamic>() ?? {};

    final String commentId = (responseJson['name'] as String?) ?? '';
    final Comment createdComment = Comment(
      id: commentId,
      artistId: artistId,
      text: text,
      createdAt: now,
    );

    final List<Comment> current = _cachedCommentsByArtistId[artistId] ?? [];
    _cachedCommentsByArtistId[artistId] = [createdComment, ...current];

    return createdComment;
  }
}
