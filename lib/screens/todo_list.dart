import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/screens/add_task.dart';
import 'package:http/http.dart' as http;
import 'package:todo/services/todo_services.dart';

import '../utils/snackbarHelper.dart';
import '../widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  bool isLoading = true;
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Todo List')
      ),
      body:
       Visibility(
        visible: isLoading,
        child: Center(child:CircularProgressIndicator()),
         replacement: RefreshIndicator(
          onRefresh: fetchTodo,
           child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item',
              style:Theme.of(context).textTheme.displaySmall
              ),
            ),
             child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context,index){
              final item = items[index] as Map;
              final id = item['_id'];
              return todoCard(
                index: index,
                deleteById: deleteById,
                navigateEdit: navigateToEditPage,
                item:item,
              );
                 }),
           ),
         ),
       ),
      floatingActionButton: FloatingActionButton.extended(onPressed:navigateToAddTaskPage, label:Text('Add Todo')),
    );
  }

  void navigateToAddTaskPage() async{
    final route = MaterialPageRoute(
      builder: (context) => AddTaskPage()
      );
      await Navigator.push(context,route);
      setState(() {
        isLoading = true;
      });
      fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(
      builder: (context) => AddTaskPage(task: item,)
      );
      await Navigator.push(context,route);
      setState(() {
        isLoading = true;
      });
      fetchTodo();
  }

  Future<void> deleteById(String id) async {
    // Delete the item
    final success = await TodoService.deleteById(id);
    if(success){
    // Remove the item from the list
    final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }else {
      // show error
      showErrorMessage(context,message:'Deletion Failed');
    }
  }
  
  Future<void> fetchTodo() async {
    final response =await TodoService.fetchTodos();
    if(response != null) {
      setState(() {
        items = response;
      });
    }else{
      showErrorMessage(context,message:'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }


}