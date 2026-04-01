import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists({bool forceFetch = false});

  Future<Artist?> fetchArtistById(String id);

  Future<List<Song>> fetchSongsByArtistId(
    String artistId, {
    bool forceFetch = false,
  });

  Future<List<Comment>> fetchCommentsByArtistId(
    String artistId, {
    bool forceFetch = false,
  });

  Future<Comment> addComment({required String artistId, required String text});
}
