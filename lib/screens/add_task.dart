import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/services/todo_services.dart';

import '../utils/snackbarHelper.dart';

class AddTaskPage extends StatefulWidget {
  final Map? task;
  const AddTaskPage({
    super.key,
    this.task,
    });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final task = widget.task;
    if(widget.task != null){
      isEdit = true;
      final title = task!['title'];
      final description = task['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText:'Title'
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: isEdit ? updateData : submitData, child:Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(isEdit ? 'Update':'Submit'),
          ),)
        ],
      ),
    );
  }

  void updateData() async {
    // Get the data from the form
    final todo = widget.task;
    if(todo == null){
      print("You cannot call updated without todo data");
      return;
    }
    final id = todo['_id'] as String;

    // submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);

      //show success or fail message based on status
      if(isSuccess) {
        showSuccessMessage(context,message: 'Updation Success');
        Navigator.pop(context);
      }else {
        showErrorMessage(context, message:'Updation failed');
      }
  }

  void submitData() async{

    // Submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    // show success or fail message on status
    if(isSuccess){
      titleController.text = '';
      descriptionController.text = '';
      print('Success');
      showSuccessMessage(context,message:'Creation Success');
    }else{
      print('Creation failed');
      showErrorMessage(context, message:'Creation Failed');
    }
  }

// Get body for post and update function
  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
     return {
      "title": title,
      "description":description,
      "is_completed": false, 
    };
  }

}