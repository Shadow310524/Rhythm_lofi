import 'package:flutter/material.dart';
import '../../song.dart';
import 'player_screen.dart'; // Make sure to import your PlayerScreen

class SearchScreen extends StatefulWidget {
  final List<Song> songs;

  const SearchScreen({Key? key, required this.songs}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Song> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _filteredSongs = widget.songs;
  }

  void _filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSongs = widget.songs;
      } else {
        _filteredSongs = widget.songs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()) ||
                song.artist.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _filterSongs,
          decoration: InputDecoration(
            hintText: 'Search songs...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredSongs.length,
        itemBuilder: (context, index) {
          final song = _filteredSongs[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the PlayerScreen with animation
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PlayerScreen(song: song),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0); // Slide in from bottom
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
              ));
            },
            child: ListTile(
              leading: Image.network(
                song.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    width: 50,
                    height: 50,
                    child: const Center(child: Icon(Icons.error)),
                  );
                },
              ),
              title: Text(song.title),
              subtitle: Text(song.artist),
            ),
          );
        },
      ),
    );
  }
}
