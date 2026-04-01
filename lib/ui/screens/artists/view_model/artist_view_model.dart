import 'package:flutter/material.dart';

import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';

class ArtistViewModel extends ChangeNotifier {
  final String artistId;
  final ArtistRepository artistRepository;

  List<Song> songs = [];
  List<Comment> comments = [];
  bool isLoading = true;
  String? errorMessage;

  ArtistViewModel({required this.artistId, required this.artistRepository}) {
    fetchData();
  }

  Future<void> fetchData({bool forceFetch = false}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      songs = await artistRepository.fetchSongsByArtistId(
        artistId,
        forceFetch: forceFetch,
      );
      comments = await artistRepository.fetchCommentsByArtistId(
        artistId,
        forceFetch: forceFetch,
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addComment(String text) async {
    final String value = text.trim();
    if (value.isEmpty) return false;

    try {
      final Comment newComment = await artistRepository.addComment(
        artistId: artistId,
        text: value,
      );
      comments = [newComment, ...comments];
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
