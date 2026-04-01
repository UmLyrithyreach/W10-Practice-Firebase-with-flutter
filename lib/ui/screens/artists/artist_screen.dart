import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/artist/artist_repository.dart';
import '../../../model/artist/artist.dart';
import 'view_model/artist_view_model.dart';
import 'widgets/artist_song_tile.dart';
import 'widgets/comment_tile.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistViewModel(
        artistId: artist.id,
        artistRepository: context.read<ArtistRepository>(),
      ),
      child: _ArtistContent(artist: artist),
    );
  }
}

class _ArtistContent extends StatefulWidget {
  const _ArtistContent({required this.artist});

  final Artist artist;

  @override
  State<_ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<_ArtistContent> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ArtistViewModel mv = context.watch<ArtistViewModel>();

    Widget body;
    if (mv.isLoading) {
      body = Center(child: CircularProgressIndicator());
    } else if (mv.errorMessage != null) {
      body = Center(
        child: Text(mv.errorMessage!, style: TextStyle(color: Colors.red)),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: () => mv.fetchData(forceFetch: true),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'Songs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (mv.songs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No songs yet'),
              )
            else
              ...mv.songs.map((song) => ArtistSongTile(song: song)),
            SizedBox(height: 16),
            Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (mv.comments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No comments yet'),
              )
            else
              ...mv.comments.map((comment) => CommentTile(comment: comment)),
            SizedBox(height: 80),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.artist.name)),
      body: body,
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final bool isAdded = await mv.addComment(
                  _commentController.text,
                );
                if (isAdded) {
                  _commentController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Comment cannot be empty or failed to post',
                      ),
                    ),
                  );
                }
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
