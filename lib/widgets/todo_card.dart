import 'package:flutter/material.dart';

class todoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  const todoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Dismissible(
      onDismissed: (direction){
        if(direction == DismissDirection.endToStart){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Item Deleted',style:TextStyle(color:Colors.white)), backgroundColor:Colors.red));
          deleteById(id);
        }
      },
          key:Key(id),
      child: Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title:Text(item['title']),
                    subtitle: Text(item['description']),
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
                    trailing: IconButton(icon: Icon(Icons.edit),onPressed: () {
                      navigateEdit(item);
                    },),
                  ),
                ),
    );
  }
}