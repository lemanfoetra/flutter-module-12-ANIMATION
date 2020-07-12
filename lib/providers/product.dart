import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> setFavorite(String authToken, String userId) async {
    bool oldFavorite = isFavorite;
    bool newStsFavorite = !isFavorite;
    try {
      // update isFavorite di local
      isFavorite = newStsFavorite;
      notifyListeners();

      // update isFavorite di server
      final url = "https://flutter-shopapps.firebaseio.com/productFavorite/$userId/$id.json?auth=$authToken";
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': newStsFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
        return throw response.body;
      }
    } catch (error) {
      throw error;
    }
  }
}
