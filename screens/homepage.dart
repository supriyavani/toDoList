import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/todomodel.dart';
import 'package:flutter_application_2/screens/addList.dart';
import 'package:flutter_application_2/utilities/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ToDoModel> _toDoList = null;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (_toDoList == null) {
      _toDoList = [];
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD NEW ITEM'),
      ),
      body: populateListView(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigationToViewModel(
                ToDoModel("", "", "", ""), " CREATE NEW LIST ");
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  updateListView() async {
    _toDoList = await databaseHelper.getPojo();
    setState(() {
      _toDoList = _toDoList;
      count = _toDoList.length;
    });
  }

  ListView populateListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          ToDoModel toDoModel = this._toDoList[index];
          return Card(
            color: toDoModel.status == "Pending" ? Colors.red : Colors.green,
            child: GestureDetector(
              onTap: () {
                navigationToViewModel(toDoModel, "Update List");
              },
              child: ListTile(
                leading: toDoModel.status == "Pending"
                    ? Icon(Icons.warning)
                    : Icon(Icons.done_all),
                title: Text(toDoModel.title),
                subtitle: Text(toDoModel.description),
                trailing: toDoModel.status == "Completed"
                    ? GestureDetector(
                      child: Icon(Icons.delete),
                        onTap: () {
                          deleteItem(toDoModel);
                        },
                      )
                    : null,
              ),
            ),
          );
        });
  }

  deleteItem(ToDoModel toDoModel) async {
    int results = await databaseHelper.delete(toDoModel);
    if (results != 0) {
      var snackBar = SnackBar(
        content: Text(
          'Succesfully deleted',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      updateListView();
    }
  }

  navigationToViewModel(ToDoModel toDoModel, String appBarTitle) async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddList(toDoModel,appBarTitle)));

    if (result) {
      updateListView();
    }
  }
}
