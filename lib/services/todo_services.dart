import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';


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

  static Future<List?> fetchTodos() async {
    // get using Dio
    try {
      final response =
          await Dio().get('http://api.nstack.in/v1/todos?page=1&limit=10');
      if (response.statusCode == 200) {
        final json = response.data;
        final result = json['items'] as List;
        return result;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
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

  static Future<bool> updateTodo(String id, Map body) async {

    final response = await Dio().put('http://api.nstack.in/v1/todos/$id',data: body);
    return response.statusCode == 200;

    // final url = 'http://api.nstack.in/v1/todos/$id';
    // final uri = Uri.parse(url);
    // final response = await http.put(
    //   uri,
    //   body: jsonEncode(body),
    //   headers: {'Content-Type': 'application/json'},
    // );
    // return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {

      final response = await Dio().post('http://api.nstack.in/v1/todos', data: body);
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
