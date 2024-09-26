import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../song.dart'; // Ensure to import your Song model

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0;

  // State for shuffle and repeat
  bool _isShuffled = false;
  bool _isRepeated = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
      if (_isPlaying) {
        _showNotification();
      } else {
        _flutterLocalNotificationsPlugin.cancel(0);
      }
    });
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'This channel is for playing notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      fullScreenIntent: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Now Playing',
      '${widget.song.title} by ${widget.song.artist}',
      platformChannelSpecifics,
      payload: widget.song.audioUrl,
    );
  }

  void _playPause() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_position == Duration.zero) {
          await _audioPlayer.setSource(UrlSource(widget.song.audioUrl));
        } else {
          await _audioPlayer.seek(_position);
        }
        await _audioPlayer.setVolume(_volume);
        await _audioPlayer.resume();
      }
      setState(() {
        _isPlaying = !_isPlaying;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  void _nextTrack() {
    // Implement logic to go to the next track
  }

  void _previousTrack() {
    // Implement logic to go to the previous track
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffled = !_isShuffled;
    });
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeated = !_isRepeated;
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _flutterLocalNotificationsPlugin.cancel(0);
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.network(
                    widget.song.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(child: Icon(Icons.error, color: Colors.white)),
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  // Album Art
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(blurRadius: 30, color: Colors.black38, spreadRadius: 10),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        widget.song.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(child: Icon(Icons.error, color: Colors.white)),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Song Title and Artist
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          widget.song.title,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.song.artist,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Seekbar and Duration
                  Column(
                    children: [
                      Slider(
                        activeColor: Colors.greenAccent,
                        inactiveColor: Colors.grey,
                        value: _position.inSeconds.toDouble(),
                        min: 0.0,
                        max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                        onChanged: (value) async {
                          setState(() {
                            _position = Duration(seconds: value.toInt());
                          });
                          await _audioPlayer.seek(_position);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(_position), style: const TextStyle(color: Colors.white70)),
                            Text(formatDuration(_duration), style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Controls
                  Column(
                    children: [
                      // Play/Pause, Next, Previous
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 48), // Increased size
                            onPressed: _previousTrack,
                          ),
                          IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 48, // Increased size
                            ),
                            onPressed: _playPause,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next, color: Colors.white, size: 48), // Increased size
                            onPressed: _nextTrack,
                          ),
                        ],
                      ),
                      // Shuffle and Repeat Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isShuffled ? Icons.shuffle : Icons.shuffle_on,
                              color: Colors.white,
                              size: 32, // Increased size
                            ),
                            onPressed: _toggleShuffle,
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: Icon(
                              _isRepeated ? Icons.repeat : Icons.repeat_on,
                              color: Colors.white,
                              size: 32, // Increased size
                            ),
                            onPressed: _toggleRepeat,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Volume Control
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Volume',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Slider(
                          value: _volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                            });
                            _audioPlayer.setVolume(_volume);
                          },
                          activeColor: Colors.greenAccent,
                          inactiveColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
