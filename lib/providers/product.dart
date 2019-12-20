import 'dart:convert';
import 'dart:io';

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

  Future<void> toggleFavoriteStatus(String userId, String token) async {
    final String url =
        'https://flutter-shop-app-5e07e.firebaseio.com/userFavourite/$userId/$id.json?auth=$token';

    isFavorite = !isFavorite;
    notifyListeners();
    await http
        .put(
      url,
      body: json.encode(isFavorite),
    )
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.statusCode);
//        print(isFavorite);

      } else {
        isFavorite = !isFavorite;
        print(isFavorite);

        notifyListeners();
        throw HttpException("Can't change favorite!!!");
      }
    });
//    isFavorite = !isFavorite;
    notifyListeners();
//    print(isFavorite);
  }
}
