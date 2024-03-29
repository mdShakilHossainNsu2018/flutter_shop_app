import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  bool isFavourite;
  ProductsGrid(this.isFavourite);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        (isFavourite ? productsData.favouriteItem : productsData.items);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(
//              products[i].id, products[i].imageUrl, products[i].title
              )),
      itemCount: products.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}
