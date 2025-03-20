import 'package:flutter/material.dart';

class ChangeBGScreen extends StatefulWidget {
  const ChangeBGScreen({super.key});

  @override
  ChangeBGScreenState createState() => ChangeBGScreenState();
}

class ChangeBGScreenState extends State<ChangeBGScreen> {
  Color bgColor = Colors.white;
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Background")),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            onSwipe("left");
          } else if (details.primaryVelocity! > 0) {
            onSwipe("right");
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            onSwipe("up");
          } else if (details.primaryVelocity! > 0) {
            onSwipe("down");
          }
        },
        child: Center( // Ensures the AnimatedContainer is centered
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500), // Smooth transition
            color: bgColor,
            width: double.infinity, // Ensures it fills the screen
            height: double.infinity, // Ensures it fills the screen
            child: Center( // Ensures the text is centered within the container
              child: Text(
                "Swipe anywhere to change background color",
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                textAlign: TextAlign.center, // Ensures multi-line text is centered
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "To Do"),
          BottomNavigationBarItem(icon: Icon(Icons.change_circle), label: "Change BG"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music MP3"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  void onSwipe(String direction) {
    setState(() {
      switch (direction) {
        case "left":
          bgColor = Colors.red;
          break;
        case "right":
          bgColor = Colors.green;
          break;
        case "up":
          bgColor = Colors.blue;
          break;
        case "down":
          bgColor = Colors.yellow;
          break;
      }
    });

    // Show a SnackBar with the swipe direction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Swiped $direction!")),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/audioplayer');
    }
  }
}