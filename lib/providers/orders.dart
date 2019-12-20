import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  Future<void> fetchAndSetOrder() async {
    final String url =
        'https://flutter-shop-app-5e07e.firebaseio.com/orders/$userId/.json?auth=$token';

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) =>
                CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
          )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

//    final response = await http.get(url);
//    final List<OrderItem> loadedOrders = [];
//    final extractedData = json.decode(response.body) as Map<String, dynamic>;
//    if (extractedData == null) {
//      return;
//    }
//    extractedData.forEach((orderId, orderData) {
//      loadedOrders.add(
//        OrderItem(
//          id: orderId,
//          amount: orderData['amount'],
//          dateTime: DateTime.parse(orderData['dateTime']),
//          products: (orderData['products'] as List<dynamic>)
//              .map(
//                (item) => CartItem(
//              id: item['id'],
//              price: item['price'],
//              quantity: item['quantity'],
//              title: item['title'],
//            ),
//          )
//              .toList(),
//        ),
//      );
//    });
//    _orders = loadedOrders.reversed.toList();
//    notifyListeners();
//  }

  Future<void> addOrder(List<CartItem> cartItem, double total) async {
    final String url =
        'https://flutter-shop-app-5e07e.firebaseio.com/orders/$userId/.json?auth=$token';

    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartItem
              .map((cp) =>
          {
            'id': cp.id,
            'title': cp.title,
            'price': cp.price,
            'quantity': cp.quantity
          })
              .toList()
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartItem,
            dateTime: DateTime.now()));
    notifyListeners();
  }

  void removeItem(String productId) {
    _orders.remove(productId);
    notifyListeners();
  }

//  void clear() {
//    _items = {};
//  }
}
