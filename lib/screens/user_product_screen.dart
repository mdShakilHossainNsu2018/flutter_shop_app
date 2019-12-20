import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static final userProductScreenName = '/userProductscreen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
//    final productData = Provider.of<Products>(context);
    return RefreshIndicator(
      onRefresh: () => _refreshProduct(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User products'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: _refreshProduct(context),
          builder: (context, snapShot) =>
          snapShot.connectionState == ConnectionState.waiting
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Consumer<Products>(
            builder: (context, productData, child) =>
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemBuilder: (context, i) =>
                        Column(
                          children: <Widget>[
                            UserProductItem(
                                productData.items[i].id,
                                productData.items[i].title,
                                productData.items[i].imageUrl),
                            Divider(),
                          ],
                        ),
                    itemCount: productData.items.length,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
