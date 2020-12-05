import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart_items_provider.dart';
import './cart_items_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders(Map<String,String>  token) {
    var url =
        "https://flutterpractice-f6dd8.firebaseio.com/userData/${token['userID']}/orders.json?auth=${token['token']}";
    return http.get(url).then((response) {
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedData = [];
      if (fetchedData == null) {
        return;
      }
      fetchedData.forEach((orderId, orderData) {
        var products = orderData['products'] as List<dynamic>;
        List<CartItem> prodList = [];
        products.forEach((element) {
          var item = CartItem(
              id: element['id'],
              title: element['title'],
              price: element['price'],
              count: element['count']);
          prodList.add(item);
        });
        loadedData.insert(
            0,
            OrderItem(
                id: orderId,
                amount: orderData['amount'],
                products: prodList,
                dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedData;
      notifyListeners();
    });
  }

  Future<void> addOrder(double amount, List<CartItem> products,Map<String,String>  token) async {
    var url =
        "https://flutterpractice-f6dd8.firebaseio.com/userData/${token['userID']}/orders.json?auth=${token['token']}";
    final timestamp = DateTime.now();
    return http
        .post(url,
            body: json.encode({
              "amount": amount,
              "products": products
                  .map((e) => {
                        "id": e.id,
                        "title": e.title,
                        "count": e.count,
                        "price": e.price,
                      })
                  .toList(),
              "dateTime": timestamp.toIso8601String()
            }))
        .then((response) {
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: amount,
              products: products,
              dateTime: timestamp));
      notifyListeners();
    });
  }
}
