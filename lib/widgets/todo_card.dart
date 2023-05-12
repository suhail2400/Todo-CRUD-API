import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final TodoModel todo;
  final Function(TodoModel) navigateEdit;
  final Function(String) deleteById;
  const TodoCard(
      {super.key,
      required this.index,
      required this.todo,
      required this.navigateEdit,
      required this.deleteById});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Item Deleted', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red));
          deleteById(todo.id.toString());
        }
      },
      key: Key(todo.id.toString()),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(todo.title ?? ''),
          subtitle: Text(todo.description ?? ''),
          // trailing: PopupMenuButton(
          //   onSelected: (value){
          //     if(value == 'edit'){
          //       // open edit
          //       navigateEdit(item);
          //     }else if (value == 'delete'){
          //       // delete and remove the item
          //       deleteById(id);
          //     }
          //   },
          //   itemBuilder: (context){
          //     return [
          //       PopupMenuItem(
          //         child:Text('Edit'),
          //         value: 'edit',
          //         ),
          //       PopupMenuItem(
          //         child:Text('Delete'),
          //         value:'delete'
          //         )
          //     ];
          //   },
          // ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              navigateEdit(todo);
            },
          ),
        ),
      ),
    );
  }
}
