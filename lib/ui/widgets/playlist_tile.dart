import 'package:flutter/material.dart';
import '../../models/models.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;

  const PlaylistTile({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.name),
      subtitle: Text('${playlist.songs.length} songs'),
      onTap: () {
        // Navigate to playlist detail or play songs
      },
    );
  }
}
