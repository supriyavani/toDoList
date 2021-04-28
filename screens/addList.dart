import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/todomodel.dart';
import 'package:flutter_application_2/utilities/database.dart';
import 'package:intl/intl.dart';

class AddList extends StatefulWidget {

  ToDoModel toDoModel;
  String appBartitle;

  AddList(this.toDoModel, this.appBartitle);

  @override
  _AddListState createState() => _AddListState(toDoModel, appBartitle);
}

class _AddListState extends State<AddList> {

  ToDoModel toDoModel;
  String appBartitle;

  
  var _statusList = ["Pending","Completed"];
  var selectedStatus = "Pending";

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();

  _AddListState(this.toDoModel, this.appBartitle);

  void initState() {
    selectedStatus = toDoModel.status.length == 0 ? "Pending" : toDoModel.status;
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    _title.text = toDoModel.title;
    _description.text = toDoModel.description;
    return Scaffold(
        appBar: AppBar(
          title: Text(appBartitle),
        ),
        body: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          child: Column(children: [
            DropdownButton(
             value: selectedStatus,
              items: _statusList
                  .map((item) {
                  return DropdownMenuItem(
                        child: Text(item),
                        value: item);
                        })
                  .toList(),
              
              onChanged: (item) {
                setState(() {
                  selectedStatus = item;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _title,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter title',
                  labelText: 'title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description',
                  labelText: 'Description'),
            ),
            SizedBox(height: 20),
            Container(
                width: double.infinity,
                child: ElevatedButton(
                  
                    onPressed: () {
                      validate();
                      var snackBar = SnackBar(
                        content: Text(
                          'Added to your To-Do-List',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.white,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text('ADD')))
          ]),
        ));
  }

  validate() {
    toDoModel.title = _title.text;
    toDoModel.description = _description.text;
    toDoModel.status = selectedStatus;
    toDoModel.date = DateFormat.yMMMd().format(DateTime.now());
    DatabaseHelper databaseHelper = DatabaseHelper();
    if (toDoModel.id == null)
      databaseHelper.insert(toDoModel);
    else
      databaseHelper.update(toDoModel);
    Navigator.pop(context, true);
  }
}
