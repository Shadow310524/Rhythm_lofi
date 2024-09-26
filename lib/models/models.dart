class Song {
  final String title;
  final String artist;
  final String url; // URL for streaming or local file path

  Song({required this.title, required this.artist, required this.url});
}

class Playlist {
  String name;
  List<Song> songs;

  Playlist({required this.name, required this.songs});
}
