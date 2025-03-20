import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  AudioPlayerScreenState createState() => AudioPlayerScreenState();
}

class AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  double _currentPosition = 0;
  double _totalDuration = 1;
  
  // Track details (example)
  String _currentTrackName = "Omanji";

  @override
  void initState() {
    super.initState();

    // Listen to position changes and update the UI
    _player.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position.inSeconds.toDouble();
      });
    });

    // Listen to track duration changes and update the total duration
    _player.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration.inSeconds.toDouble();
      });
    });

    // Listen for changes in player state, including completion
    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
          _currentPosition = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
        backgroundColor: const Color.fromARGB(255, 254, 254, 254),
      ),
      body: Center(
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Album art placeholder (you can add an actual image later)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurpleAccent,
                ),
                child: Center(
                  child: Icon(Icons.music_note, size: 100, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // Track name
              Text(
                _currentTrackName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Play/Pause button
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 80,
                  color: Colors.deepPurpleAccent,
                ),
                onPressed: _togglePlayPause,
              ),
              SizedBox(height: 20),
              // Track progress slider
              Slider(
                value: _currentPosition,
                min: 0,
                max: _totalDuration,
                onChanged: (double value) {
                  setState(() {
                    _currentPosition = value;
                  });
                  _player.seek(Duration(seconds: value.toInt()));
                },
              ),
              SizedBox(height: 20),
              // Song duration
              Text(
                "${_formatDuration(Duration(seconds: _currentPosition.toInt()))} / ${_formatDuration(Duration(seconds: _totalDuration.toInt()))}",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              // Music selection buttons
              ElevatedButton(
                onPressed: () => _playTrack("omanji.mp3", "Omanji"),
                child: Text("Play Music 1"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _playTrack("tobitoptop.mp3", "Tobitoptop"),
                child: Text("Play Music 2"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _playTrack("u ii a a.mp3", "U II A A"),
                child: Text("Play Music 3"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "To Do"),
          BottomNavigationBarItem(icon: Icon(Icons.change_circle), label: "Change BG"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music MP3"),
        ],
        currentIndex: _selectedIndex, // Highlights the selected item
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });

    // Navigate to the corresponding screen
    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/changebg');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/audioplayer');
    }
  }

  // Function to toggle between play and pause
  void _togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _playCurrentTrack();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Play the current track
  void _playCurrentTrack() async {
    if (_currentTrackName == "Omanji") {
      await _player.play(AssetSource("omanji.mp3"));
    } else if (_currentTrackName == "Tobitoptop") {
      await _player.play(AssetSource("tobitoptop.mp3"));
    } else if (_currentTrackName == "U II A A") {
      await _player.play(AssetSource("u ii a a.mp3"));
    }
  }

  // Helper function to format duration
  String _formatDuration(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  // Play a given track with its name
  void _playTrack(String trackPath, String trackName) async {
    // Stop any currently playing track
    await _player.stop();

    // Play the selected track
    await _player.play(AssetSource(trackPath));

    setState(() {
      _currentTrackName = trackName;
      _isPlaying = true;
      _currentPosition = 0; // Reset position to 0 when switching tracks
    });
  }
}
