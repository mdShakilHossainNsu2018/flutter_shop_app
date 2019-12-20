import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { ShowAll, Favourites }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _isFavourite = false;
  bool _init = false;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (!_init) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshOverviewItems(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(
                      badgeContent: Text(cart.itemCount.toString()),
                      position: BadgePosition.topRight(top: -1, right: -2),
                      child: ch),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.cartScreenName);
                  }),
            ),
            PopupMenuButton(
              elevation: 5.0,
              onSelected: (FilterOptions result) {
                setState(() {
                  if (result == FilterOptions.Favourites) {
                    _isFavourite = true;
                  } else {
                    _isFavourite = false;
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
              [
                const PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.ShowAll,
                ),
                const PopupMenuItem(
                  child: Text('Favourites Only'),
                  value: FilterOptions.Favourites,
                ),
              ],
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ProductsGrid(_isFavourite),
      ),
    );
  }

  Future<void> _refreshOverviewItems(BuildContext context) async {
//    setState(() {
//      _isLoading = true;
//    });

    await Provider.of<Products>(context).fetchAndSetProducts().then((_) {
//      setState(() {
//        _isLoading = false;
//      });
    });
  }
}
