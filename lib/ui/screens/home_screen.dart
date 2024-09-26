import 'package:flutter/material.dart';
import 'package:rhythm_lofi/ui/widgets/bottom_navbar.dart';
import 'package:rhythm_lofi/ui/screens/player_screen.dart';
import 'package:rhythm_lofi/ui/screens/search_screen.dart';
import '../../song.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isDarkMode = false;
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  final List<Song> songs = [
    Song(
      title: 'Manasilayo',
      artist: 'Anirudh Ravichander, Deepthi Suresh',
      audioUrl: 'https://drive.google.com/uc?export=download&id=1G7BSiCo6UUbhOowcu4mT7sB8kXK5BA73',
      imageUrl: 'https://www.ntvenglish.com/wp-content/uploads/2024/09/ms.jpg',
    ),
    Song(
      title: 'Vaadi Pulla Vaadi',
      artist: 'Hip hop Tamizha',
      audioUrl: 'https://drive.google.com/uc?export=download&id=1sqLAzTb3nBtWI9VasY_-JvcgUNGTHFfk',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273730b31b52338a2ea1d9e9321',
    ),
    Song(
      title: 'Saarattu Vandiyile',
      artist: 'Vivek-Mervin',
      audioUrl: 'https://drive.google.com/uc?export=download&id=1x6wb3y3b4M9mvGBIsBzBTDkA1rZpk7Eo',
      imageUrl: 'https://static.langimg.com/photo/imgsize-42231,msid-57413035/tamil-samayam.jpg',
    ),
    Song(
      title: 'Marana Mass',
      artist: 'Anirudh Ravichander',
      audioUrl: 'https://drive.google.com/uc?export=download&id=1EHYUuIiTg8FCzLUbnBMVxnT5oX-AoeCx',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b2735d8a02be184c2ccb0f88aeb5',
    ),
    Song(
      title: 'Dheera Dheera',
      artist: 'Vishal Chandrasekhar',
      audioUrl: 'https://drive.google.com/uc?export=download&id=1L4AiF1EgQOWjUNWKrcHNnhT6cIsavPyh',
      imageUrl: 'https://c.saavncdn.com/389/KGF-Chapter-1-Malayalam-2018-20190318131056-500x500.jpg',
    ),
    Song(
      title: 'Rowdy Baby',
      artist: 'Dhanush, Dhee',
      audioUrl: 'https://drive.google.com/uc?export=download&id=1uhZshGhvz0JQMXh-83HelsMjUcJ5lOwI',
      imageUrl: 'https://images.filmibeat.com/img/2019/02/rowdybabyvideosong-1550042067.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rhythm Lofi'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to SearchScreen with fade transition
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(songs: songs),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ));
              },
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeInAnimation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(song: song),
                            ),
                          );
                        },
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isDarkMode ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: _isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    song.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        width: 100,
                                        height: 100,
                                        child: const Center(child: Icon(Icons.error)),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        song.artist,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _isDarkMode ? Colors.white70 : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
