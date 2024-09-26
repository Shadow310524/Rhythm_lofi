import 'package:flutter/material.dart';
import '../widgets/playlist_tile.dart'; // Import Playlist Tile widget
import '../../services/playlist_service.dart'; // Import Playlist Service

class PlaylistScreen extends StatelessWidget {
  final PlaylistService _playlistService = PlaylistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Code to add a new playlist
              // You can use showDialog() to take playlist name input
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _playlistService.playlists.length,
        itemBuilder: (context, index) {
          final playlist = _playlistService.playlists[index];
          return PlaylistTile(playlist: playlist); // Custom widget to display each playlist
        },
      ),
    );
  }
}
