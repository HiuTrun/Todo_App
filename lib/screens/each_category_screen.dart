import 'package:eltodo/models/todo.dart';
import 'package:eltodo/services/todo_service.dart';
import 'package:flutter/material.dart';

class TodoByCategoryScreen extends StatefulWidget {
  final String category;
  TodoByCategoryScreen({this.category});
  @override
  _TodoByCategoryScreenState createState() => _TodoByCategoryScreenState();
}

class _TodoByCategoryScreenState extends State<TodoByCategoryScreen> {
  List<Todo> _todoList = List<Todo>();

  TodoService _todoService = TodoService();

  _getAllTodo() async {
    var todos = await _todoService.todosByCategory(this.widget.category);
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        _todoList.add(model);
      });
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context,index){
                return  Text(_todoList[index].title);
              },
            ),
          ),
        ],
      ),
    );
  }
}
