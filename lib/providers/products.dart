import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  final String token;

  final String userId;

  Products(this.token, this.userId, this._items);
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItem {
    return items.where((fev) => fev.isFavorite == true).toList();
  }

  findItemById(String id) {
    return items.firstWhere((prodId) => prodId.id == id);
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    final String url =
        'https://flutter-shop-app-5e07e.firebaseio.com/products/$id.json?auth=$token';

    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'imageUrl': newProduct.imageUrl,
            'description': newProduct.description,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final String url =
        'https://flutter-shop-app-5e07e.firebaseio.com/products/$id.json?auth=$token';

    await http.delete(url).then((resp) {
//      print(resp.statusCode);
      if (resp.statusCode == 200) {
        _items.removeWhere((prod) => prod.id == id);
      } else {
        throw HttpException("couldn't delete");
      }
    });

    notifyListeners();
  }

  Future<void> fetchAndSetProducts([bool filterByUserId = false]) async {
    final filter =
    filterByUserId ? '&orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://flutter-shop-app-5e07e.firebaseio.com/products.json?auth=$token$filter';

    try {
      final response = await http.get(url);

      final extractData = json.decode(response.body) as Map<String, dynamic>;

      if (extractData == null) {
        return;
      }

      url =
      'https://flutter-shop-app-5e07e.firebaseio.com/userFavourite/$userId.json?auth=$token';

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> fetchedList = [];

      extractData.forEach((prodId, value) {
        fetchedList.add(Product(
          id: prodId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite:
          favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });

      _items = fetchedList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
//    print(json.decode(response.body));
  }

  Future<void> addProduct(Product product) {
    final String url =
        'https://flutter-shop-app-5e07e.firebaseio.com/products.json?auth=$token';

    return http
        .post(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
//              'isFavorite': product.isFavorite
        }))
        .then((response) {
      final _newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(_newProduct);
      notifyListeners();
    });

//    notifyListeners();
  }
}
