import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/add_task.dart';
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
    super.initState();
    fetchTodo();
  }

  List<TodoModel> itemlist = <TodoModel>[];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body:Visibility(
        visible: isLoading,
        child: Center(child:CircularProgressIndicator()),
         replacement: RefreshIndicator(
          onRefresh: fetchTodo,
           child: Visibility(
            visible: itemlist.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item',
              style:Theme.of(context).textTheme.displaySmall
              ),
            ),
            child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: itemlist.length,
          itemBuilder: (context, index) {
            return TodoCard(
                index: index,
                deleteById: deleteById,
                navigateEdit: navigateToEditPage,
                todo: itemlist[index]);
          }),
      ),)),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddTaskPage, label: const Text('Add Todo')),
    );
  }

  void navigateToAddTaskPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTaskPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(TodoModel item) async {
    final route = MaterialPageRoute(
        builder: (context) => AddTaskPage(
              task: item,
            ));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    try {
      isLoading = true;
      final todos = await TodoService.fetchTodos();

      itemlist = todos;

      isLoading = false;
      setState(() {});
    } catch (e) {
      showErrorMessage(context, message: 'Something went wrong');
      print(e);
    }
  }

  Future<void> deleteById(String id) async {
    // Delete the item
    final success = await TodoService.deleteById(id);
    if (success) {
      // Remove the item from the list
      final filtered = itemlist.where((element) => element.id != id).toList();
      // final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        itemlist = filtered;
      });
    } else {
      // show error
      showErrorMessage(context, message: 'Deletion Failed');
    }
  }
}
