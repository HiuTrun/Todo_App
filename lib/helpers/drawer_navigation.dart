import 'package:eltodo/screens/categories_screen.dart';
import 'package:eltodo/screens/each_category_screen.dart';
import 'package:eltodo/screens/home_screen.dart';
import 'package:eltodo/services/category_service.dart';
import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  CategoryService _categoryService = CategoryService();

  List<Widget> _categoryList = List<Widget>();

  _getAllCategories() async {
    var categories = await _categoryService.getCategories();
    categories.forEach((item)  {
      setState(() {
        _categoryList.add(
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TodoByCategoryScreen(category: item['name'],)));
            },
            child: ListTile(
              title: Text(item['name']),
            ),
          ),
        );
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("EL Todo"),
            accountEmail: Text("Category & Priority based Todo App"),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: FlutterLogo(size: 50),
              ),
            ),
            decoration: BoxDecoration(color: Colors.red),
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          ListTile(
            title: Text('Categories'),
            leading: Icon(Icons.view_list),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
          ),
          Divider(),
          Column(
            children: _categoryList,
          ),
        ],
      ),
    );
  }
}
