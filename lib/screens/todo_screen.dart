import 'package:eltodo/models/todo.dart';
import 'package:eltodo/services/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:eltodo/services/category_service.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitle = TextEditingController();
  var _todoDescription = TextEditingController();
  var _todoDate = TextEditingController();
  var _categories = List<DropdownMenuItem>();
  var _selectedValue;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TodoService _todoService = TodoService();


  @override
  initState() {
    super.initState();
    _loadCategories();

  }


  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
            child: Text(category['name']),
            value: category['name'],
          ),
        );
      });
    });
  }

  DateTime _date = DateTime.now();
  _selectTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickedDate != null) {
      setState(() {
        _date = _pickedDate;
        _todoDate.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _todoTitle,
            decoration:
                InputDecoration(hintText: 'Todo title', labelText: 'Cook food'),
          ),
          TextField(
            controller: _todoDescription,
            decoration: InputDecoration(
              hintText: 'Todo description',
              labelText: 'Cook rice and curry',
            ),
          ),
          TextField(
            controller: _todoDate,
            decoration: InputDecoration(
              hintText: 'YY-MM-DD',
              labelText: 'YY-MM-DD',
              prefixIcon: InkWell(
                onTap: () {
                  _selectTodoDate(context);
                },
                child: Icon(Icons.calendar_today),
              ),
            ),
          ),
          DropdownButtonFormField(
            value: _selectedValue,
            items: _categories,
            hint: Text('Select one category'),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
            },
          ),
          FlatButton(
              onPressed: () async {
                Todo todo = Todo();
                todo.title = _todoTitle.text;
                todo.description = _todoDescription.text;
                todo.todoDate = _todoDate.text;
                todo.category = _selectedValue;
                todo.isFinished = 0;
                var result = await _todoService.saveTodo(todo);
                if (result != 0) {
                  _key.currentState.showSnackBar(SnackBar(
                    content: Text('Success'),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}
