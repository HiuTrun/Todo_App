import 'package:eltodo/models/todo.dart';
import 'package:eltodo/repositories/repository.dart';

class TodoService{
  Repository _repository;
  TodoService(){
    _repository = Repository();
  }
  saveTodo(Todo todo)async{
    return await _repository.save('todos', todo.todoMap());
  }
  getTodos()async{
    return await _repository.getAll('todos');
  }

  getTodoById(todoId) async {
    return await _repository.getById('todos',todoId);
  }

  updateTodo(Todo todo) async {
    return await _repository.update('todos',todo.todoMap());
  }

  deleteTodo(todoId) async{
    return await _repository.delete('todos',todoId);
  }

  todosByCategory(String category) async{
    return await _repository.getByColumnName('todos','category',category);
  }
}