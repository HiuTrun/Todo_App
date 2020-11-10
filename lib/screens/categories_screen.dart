import 'package:eltodo/models/category.dart';
import 'package:eltodo/screens/home_screen.dart';
import 'package:eltodo/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editCategoryName = TextEditingController();
  var _editCategoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();
  
  List<Category> categoriesList = List<Category>();

  var category;


  getAllCategories() async {
    categoriesList = List<Category>();
    var categories = await _categoryService.getCategories();
    categories.forEach((category) {
      setState(() {
        var model = Category();
        model.name = category['name'];
        model.id = category['id'];
        model.description = category['description'];
        categoriesList.add(model);
      });
    });
  }

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  _showFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () async {
                    _category.name = _categoryNameController.text;
                    _category.description = _categoryNameController.text;
                    var result = await _categoryService.saveCategory(_category);
                    if(result !=0){
                      getAllCategories();
                      _categoryNameController.text ='';
                      _categoryDescriptionController.text ='';
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Save')),
            ],
            title: Text('Category form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        labelText: 'Category name',
                        hintText: 'Write category name'),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                        labelText: 'Category description',
                        hintText: 'Write category description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () async {
                    _category.id =  category[0]['id'];
                    _category.name = _editCategoryName.text;
                    _category.description = _editCategoryDescription.text;
                    var result = await _categoryService.updateCategory(_category);
                    if(result!=0){
                      Navigator.of(context).pop();
                      getAllCategories();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Success"), duration: Duration(seconds: 1),));
                    }

                  },
                  child: Text('update')),
            ],
            title: Text('Category edit form'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _editCategoryName,
                    decoration: InputDecoration(
                        labelText: 'Category name',
                        hintText: 'Write category name'),
                  ),
                  TextField(
                    controller: _editCategoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Category description',
                        hintText: 'Write category description'),
                  ),
                ],
              ),
            ),
          );
        });
  }
  _editCategory(BuildContext context, categoryId)async{
      category = await _categoryService.getCategoryById(categoryId);

     setState(() {
       _editCategoryName.text = category[0]['name']?? 'No name';
       _editCategoryDescription.text = category[0]['description']?? 'No Description';
     });
     _editCategoryDialog(context);
  }

  _deleteCategoryDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.green,
                  child: Text(
                    'Cancel', style: TextStyle(color: Colors.white),)),
              FlatButton(
                  onPressed: () async {
                    var result = _categoryService.deleteCategory(categoryId);
                    if(result!=0){
                      getAllCategories();
                      Navigator.of(context).pop();
                    }
                  },
                  color: Colors.red,
                  child: Text(
                    'Delete', style: TextStyle(color: Colors.white),),),
            ],
            title: Text('Are you sure, you want to delete it?'),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('EI todo'),
        leading: RaisedButton(
          color: Colors.red,
          elevation: 0,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    _editCategory(context, categoriesList[index].id);
                  },
                  icon: Icon(Icons.edit),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(categoriesList[index].name),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategoryDialog(context,categoriesList[index].id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormInDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


