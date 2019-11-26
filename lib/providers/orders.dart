import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItem, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
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
