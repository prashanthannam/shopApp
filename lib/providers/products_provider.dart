import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'dart:convert';
import 'package:shopapp/providers/productItem_provider.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
    List<Product> _myitems = [];

  bool showOnlyFav = false;
  void changeToOnlyFav() {
    showOnlyFav = true;
    notifyListeners();
  }

  void changeToAll() {
    showOnlyFav = false;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }
  List<Product> get myItems {
    return [..._myitems];
  }

  List<Product> get favItems {
    _items.forEach((element) {
    });
    return [..._items.where((element) => element.isFavourite).toList()];
  }

  Product getProductByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProduct(Map<String, String> token) async {
    final url =
        "https://flutterpractice-f6dd8.firebaseio.com/products.json?auth=${token['token']}";
    return http.get(url).then((response) {
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      if (fetchedData == null) {
        return null;
      }
      var favData;
      final favUrl =
          "https://flutterpractice-f6dd8.firebaseio.com/userData/${token['userID']}/favProducts.json?auth=${token['token']}";
      return http.get(favUrl).then((res) {
        favData = json.decode(res.body);
        fetchedData.forEach((prodId, prodData) {
          loadedData.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavourite: favData == null ? false : favData[prodId] ?? false,
          ));
        });
        _items = loadedData;
        notifyListeners();
      });
    });
  }

  Future<void> fetchMyProducts(Map<String, String> token) async {
    final url =
        'https://flutterpractice-f6dd8.firebaseio.com/products.json?auth=${token['token']}&orderBy="creatorID"&equalTo="${token['userID']}"';
    return http.get(url).then((response) {
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      if (fetchedData == null) {
        return null;
      }
      
        fetchedData.forEach((prodId, prodData) {
          loadedData.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ));
        });
        _myitems = loadedData;
        notifyListeners();
    });
  }

  Future<void> addProduct(Product item, Map<String, String> token) {
    var url =
        "https://flutterpractice-f6dd8.firebaseio.com/products.json?auth=${token['token']}";
    return http
        .post(url,
            body: jsonEncode({
              "title": item.title,
              "description": item.description,
              "price": item.price,
              "imageUrl": item.imageUrl,
              "creatorID": token['userID']
            }))
        .then((value) {
      var newProduct = Product(
          id: json.decode(value.body)["name"],
          title: item.title,
          description: item.description,
          price: item.price,
          imageUrl: item.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> editProduct(Product item, Map<String, String> token) async {
    var index = _items.indexWhere((element) => element.id == item.id);
    if (index >= 0) {
      final url =
          "https://flutterpractice-f6dd8.firebaseio.com/products/${item.id}.json?auth=${token['token']}";
      await http
          .patch(url,
              body: json.encode({
                "title": item.title,
                "description": item.description,
                "price": item.price,
                "isFavourite": item.isFavourite,
                "imageUrl": item.imageUrl,
              }))
          .then((value) {
        _items[index] = item;
        notifyListeners();
      });
    }
  }

  Future<void> deleteProduct(String id, Map<String, String> token) async {
    final url =
        "https://flutterpractice-f6dd8.firebaseio.com/products/$id.json?auth=${token['token']}";
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    await http.delete(url).then((value) {
      existingProduct = null;
    }).catchError((err) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
  }

  Future<void> toggleFav(id, Map<String, String> token) async {
    var index = _items.indexWhere((element) => element.id == id);
    _items[index].isFavourite = !_items[index].isFavourite;
    notifyListeners();
    final url =
        "https://flutterpractice-f6dd8.firebaseio.com/userData/${token['userID']}/favProducts/$id.json?auth=${token['token']}";
    await http.put(url,
        body: json.encode(
          _items[index].isFavourite,
        ));
  }
}

