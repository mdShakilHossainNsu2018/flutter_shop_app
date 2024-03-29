import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingQuantity) => CartItem(
              id: existingQuantity.id,
              title: existingQuantity.title,
              quantity: existingQuantity.quantity + 1,
              price: existingQuantity.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void singleItemRemove(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingQuantity) => CartItem(
              id: existingQuantity.id,
              title: existingQuantity.title,
              quantity: existingQuantity.quantity - 1,
              price: existingQuantity.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, value) => {total += value.price * value.quantity});
    return total;
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
