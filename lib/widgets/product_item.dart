import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:flutter_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String imageUrl;
//  final String title;
//
//  ProductItem(this.id, this.imageUrl, this.title);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
                ProductDetailScreen.productDetailRouteName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => {product.toggleFavoriteStatus()},
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => {},
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
