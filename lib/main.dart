import 'package:flutter/material.dart';
import 'changebg.dart'; // Import the new screen
import 'audioplayer.dart'; // Import the new screen

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ToDoScreen(),
      routes: {
        '/changebg': (context) => const ChangeBGScreen(),
        '/audioplayer': (context) => const AudioPlayerScreen(),
      },
    );
  }
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _todoList = [];
  int _selectedIndex = 0;

  void _addToDo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todoList.add(_controller.text);
        _controller.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("To-Do item added!")),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, '/changebg');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/audioplayer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Enter a to-do item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addToDo,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: _todoList.isEmpty
                ? const Center(
                    child: Text(
                      "No to-do items yet!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline,
                              color: Colors.deepPurple),
                          title: Text(
                            _todoList[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _todoList.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("To-Do item removed!")),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToDo,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "To Do"),
          BottomNavigationBarItem(
              icon: Icon(Icons.change_circle), label: "Change BG"),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: "Music MP3"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}