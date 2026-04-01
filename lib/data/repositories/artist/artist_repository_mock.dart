import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _artists;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }

  @override
  Future<List<Song>> fetchSongsByArtistId(
    String artistId, {
    bool forceFetch = false,
  }) async {
    return Future.delayed(Duration(milliseconds: 300), () => []);
  }

  @override
  Future<List<Comment>> fetchCommentsByArtistId(
    String artistId, {
    bool forceFetch = false,
  }) async {
    return Future.delayed(Duration(milliseconds: 300), () => []);
  }

  @override
  Future<Comment> addComment({
    required String artistId,
    required String text,
  }) async {
    return Future.delayed(
      Duration(milliseconds: 300),
      () => Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        artistId: artistId,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }
}
