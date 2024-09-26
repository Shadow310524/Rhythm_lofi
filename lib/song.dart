class Song {
  final String title;
  final String artist;
  final String audioUrl;
  final String imageUrl;
  final String lyrics; // Property for lyrics

  Song({
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.imageUrl,
    this.lyrics = "No lyrics available", // Default value
  });
}
