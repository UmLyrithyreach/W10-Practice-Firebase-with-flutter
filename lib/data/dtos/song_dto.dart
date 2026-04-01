import '../../model/songs/song.dart';

class SongDto {
  static const String titleKey = 'title';
  static const String durationKey = 'duration'; // in ms
  static const String artistIdKey = 'artistId';
  static const String imageUrlKey = 'imageUrl';
  static const String likesKey = 'likes';

  static Song fromJson(String id, Map<String, dynamic> json) {
    return Song(
      id: id,
      title: (json[titleKey] as String?) ?? 'Unknown song',
      artistId: (json[artistIdKey] as String?) ?? '',
      duration: Duration(milliseconds: (json[durationKey] as num?)?.toInt() ?? 0),
      imageUrl: Uri.parse(
        (json[imageUrlKey] as String?) ??
            'https://via.placeholder.com/300x300.png?text=No+Image',
      ),
      likes: (json[likesKey] as num?)?.toInt() ?? 0,
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageUrlKey: song.imageUrl.toString(),
      likesKey: song.likes,
    };
  }
}
