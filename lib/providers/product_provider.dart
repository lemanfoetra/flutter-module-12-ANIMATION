import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = [];

  // construct
  ProductsProvider(this.authToken, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get getFavoriteItems {
    return [..._items.where((data) => data.isFavorite == true)];
  }

  // GET DATA DARI FIREBASE
  Future<void> getListProduct([bool filterUser = false]) async {

    String strFilter = "";
    if(filterUser){
      strFilter = '&orderBy="creatorId"&equalTo="$userId"';
    }
    String url =
        "https://flutter-shopapps.firebaseio.com/product.json?auth=$authToken$strFilter";

    try {

      // Mengambil data product
      final response = await http.get(url);
      final ekstrakData = json.decode(response.body) as Map<String, dynamic>;

      // mengambil data user favoriteStatus berdasarkan userId
      url = "https://flutter-shopapps.firebaseio.com/productFavorite/$userId.json?auth=$authToken";
      final responseSfavorite = await http.get(url);
      final dataStatusFavorite = json.decode(responseSfavorite.body) as Map<String, dynamic>;

      if(dataStatusFavorite['error'] != null){
        throw dataStatusFavorite['error'];
      }

      List<Product> newData = [];
      if (ekstrakData != null) {
        ekstrakData.forEach((key, value) {
          newData.add(Product(
            id: key,
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            title: value['title'],
            isFavorite: (dataStatusFavorite == null) ? false : (dataStatusFavorite[key] == null) ? false : dataStatusFavorite[key]['isFavorite'],
          ));
        });
      }
      _items = newData;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // contoh melakukan post request
    final url = "https://flutter-shopapps.firebaseio.com/product.json?auth=$authToken";

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      Product _newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      // Insert sebagai list pertama
      _items.insert(0, _newProduct);
    } catch (error) {
      throw error;
    }

    //BERFUNGSI UNTUK MEMBERITAHUKAN BAHWA ADA DATA BARU SEHINGGA WIDGET AKAN DI RE-RENDER
    notifyListeners();
  }

  Product findById(String id) {
    return items.firstWhere((data) => data.id == id);
  }

  Future<void> editProduct(String id, Product product) async {
    if (id != null) {
      final url = "https://flutter-shopapps.firebaseio.com/product/$id.json?auth=$authToken";
      await http.patch(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );
      var index = _items.indexWhere((data) => data.id == id);
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url = "https://flutter-shopapps.firebaseio.com/product/$id.json?auth=$authToken";
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw "Deleting failed, code : ${response.statusCode}";
      } else {
        _items.removeWhere((data) => data.id == id);
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  void bersihkanItems() {
    _items = [];
    //notifyListeners();
  }
}
