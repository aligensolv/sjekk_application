import 'package:flutter/material.dart';


class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<String> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index]),
                );
              },
            ),
          ),
          TextField(
            onSubmitted: (newTodo) {
              setState(() {
                todos.add(newTodo);
              });
            },
            decoration: InputDecoration(
              hintText: 'Add a new task',
              contentPadding: EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }
}