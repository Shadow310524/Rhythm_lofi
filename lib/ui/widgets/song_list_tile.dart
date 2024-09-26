// lib/ui/widgets/song_list_tile.dart

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../screens/player_screen.dart';
import '../../song.dart';

class SongListTile extends StatelessWidget {
  final Song song;

  const SongListTile({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(song.imageUrl, width: 50, height: 50),
        title: Text(song.title),
        subtitle: Text(song.artist),
        trailing: IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: PlayerScreen(song: song),
              ),
            );
          },
        ),
      ),
    );
  }
}
