import '../models/models.dart';

class PlaylistService {
  List<Playlist> playlists = [];

  void createPlaylist(String name) {
    playlists.add(Playlist(name: name, songs: []));
  }

  void addSongToPlaylist(String playlistName, Song song) {
    final playlist = playlists.firstWhere((p) => p.name == playlistName);
    playlist.songs.add(song);
  }

  void removeSongFromPlaylist(String playlistName, Song song) {
    final playlist = playlists.firstWhere((p) => p.name == playlistName);
    playlist.songs.remove(song);
  }

  // More methods can be added for editing/deleting playlists
}
