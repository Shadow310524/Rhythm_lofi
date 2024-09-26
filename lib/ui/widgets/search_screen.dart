import 'package:flutter/material.dart';
import 'package:rhythm_lofi/ui/screens/player_screen.dart';
import '../../song.dart';

class SearchScreen extends StatefulWidget {
  final List<Song> songs;

  const SearchScreen({Key? key, required this.songs}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Song> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    filteredSongs = widget.songs; // Initialize with all songs
  }

  void _filterSongs(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSongs = widget.songs; // Reset to all songs
      });
    } else {
      setState(() {
        filteredSongs = widget.songs
            .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Songs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildSongList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterSongs,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: 'Search songs',
        border: OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      itemCount: filteredSongs.length,
      itemBuilder: (context, index) {
        final song = filteredSongs[index];
        return ListTile(
          title: Text(song.title),
          subtitle: Text(song.artist),
          onTap: () {
            // Navigate to the player screen when a song is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerScreen(song: song),
              ),
            );
          },
        );
      },
    );
  }
}
  