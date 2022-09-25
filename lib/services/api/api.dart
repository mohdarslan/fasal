import 'dart:convert';

import 'package:app/models/movies.dart';
import 'package:app/services/api/api_list.dart';
import 'package:http/http.dart' as http;

class API {
  static Future<Movies> findMovies({required String query}) async {
    try {
      http.Response response =
          await http.get(Uri.parse(searchAPI + '&query=$query'));
      Map<String, dynamic> responseMap = jsonDecode(response.body);
      return Movies.fromJson(responseMap);
    } catch (e) {
      rethrow;
    }
  }
}
