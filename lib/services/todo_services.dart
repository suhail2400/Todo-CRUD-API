import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../models/todo_model.dart';

// All todo api call will be here
class TodoService {
  static Future<bool> deleteById(String id) async {
    final response = await Dio().delete('http://api.nstack.in/v1/todos/$id');
    return response.statusCode == 200;

    // final url = 'http://api.nstack.in/v1/todos/$id';
    // final uri = Uri.parse(url);
    // final response = await http.delete(uri);
    // return response.statusCode == 200;
  }

  //static Future<List?> fetchTodos() async {
  static Future<List<TodoModel>> fetchTodos() async {
    // get using Dio

    try {
      final response =
          await Dio().get('http://api.nstack.in/v1/todos?page=1&limit=10');
      // log('response = ${response.data.toString()}');
      //   if (response.statusCode == 200) {
      //     final json = response.data;
      //     final result = json['items'] as List;
      //     return result;
      //   } else {
      //     return null;
      //   }
      // } catch (e) {
      //   print(e);
      // }
      final List<TodoModel> todos = (response.data['items'] as List)
          .map((e) => TodoModel.fromJson(e))
          .toList();
      if (response.statusCode == 200) {
        return todos;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      rethrow;
    }

    //   const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    //   final uri = Uri.parse(url);
    //   final response = await http.get(uri);
    //   if(response.statusCode == 200) {
    //     final json = jsonDecode(response.body) as Map;
    //     final result = json['items'] as List;
    //     return result;
    // }else{
    //   return null;
    // }
  }

  static Future<bool> updateTodo(String id, TodoModel body) async {
    try {
      final headers = {"Content-Type": "application/json"};

      final response = await Dio().put('http://api.nstack.in/v1/todos/$id',
          data: body.toJson(), options: Options(headers: headers));
      log('response == ${response.data}');
      return response.statusCode == 200;
    } catch (e, s) {
      log('id = $id Exception: $e', stackTrace: s);
      rethrow;
      // TODO
    }

    // final url = 'http://api.nstack.in/v1/todos/$id';
    // final uri = Uri.parse(url);
    // final response = await http.put(
    //   uri,
    //   body: jsonEncode(body),
    //   headers: {'Content-Type': 'application/json'},
    // );
    // return response.statusCode == 200;
  }

  static Future<bool> addTodo(TodoModel body) async {
    final headers = {"Content-Type": 'application/json'};
    final response = await Dio().post('http://api.nstack.in/v1/todos',
        data: body.toJson(), options: Options(headers: headers));
    return response.statusCode == 201;

    // const url = 'http://api.nstack.in/v1/todos';
    // final uri = Uri.parse(url);
    // final response = await http.post(
    //   uri,
    //   body: jsonEncode(body),
    //   headers: {'Content-Type': 'application/json'},
    // );
    // return response.statusCode == 201;
  }
}
