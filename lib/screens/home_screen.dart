import 'package:eltodo/models/todo.dart';
import 'package:eltodo/screens/todo_screen.dart';
import 'package:eltodo/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:eltodo/helpers/drawer_navigation.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todoList = List<Todo>();

  var todo;
  TodoService _todoService = TodoService();

  @override
  initState() {
    super.initState();
    _getAllTodos();
  }

  _getAllTodos() async{
    todoList = List<Todo>();
    var todos = await _todoService.getTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.id = todo['id'];
        model.description = todo['description'];
        model.isFinished = todo['isFinished'];
        model.todoDate = todo['todoDate'];
        model.category = todo['category'];
        todoList.add(model);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EI todo'),
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TodoScreen()));
        },
      ),
        body: ListView.builder(itemBuilder: (context,index){
          return Card(
            child: ListTile(
              title: Text(todoList[index].title),
              subtitle: Text(todoList[index].description),
            ),
          );
        },itemCount: todoList.length),
    );
  }
}
