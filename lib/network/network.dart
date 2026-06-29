import 'dart:convert';

import 'package:book_tracker/models/book_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Network {
  static final String _baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://www.googleapis.com/books/v1/volumes';
  static final String _key = dotenv.env['API_KEY'] ?? '';

  Future<List<Book>> searchBooks(String query) async {
    var url = Uri.parse('$_baseUrl?q=$query&key=$_key');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["items"] != null && data['items'] is List) {
        List<Book> books = (data['items'] as List<dynamic>)
            .map((book) => Book.fromJson(book as Map<String, dynamic>))
            .toList();
        return books;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed man... I failed');
    }
  }
}
