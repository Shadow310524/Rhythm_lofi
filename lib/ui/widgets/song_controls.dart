import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class SongControls extends StatelessWidget {
  const SongControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
