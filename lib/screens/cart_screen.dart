import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart' show Cart;
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const cartScreenName = '/cart';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Item"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Total Price: "),
                  Chip(
                    label: Text(
                      cart.totalPrice.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _RaisedButtonWedets(cart: cart, orders: orders),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _RaisedButtonWedets extends StatefulWidget {
  const _RaisedButtonWedets({
    Key key,
    @required this.cart,
    @required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Orders orders;

  @override
  __RaisedButtonWedetsState createState() => __RaisedButtonWedetsState();
}

class __RaisedButtonWedetsState extends State<_RaisedButtonWedets> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : RaisedButton.icon(
      onPressed: widget.cart.items.length <= 0
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });
        await widget.orders.addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalPrice);
        widget.cart.clear();
        setState(() {
          _isLoading = false;
        });
      },
      icon: Icon(Icons.local_shipping),
      label: Text(
        "Order now",
        style: TextStyle(color: Colors.white),
      ),
      color: Theme
          .of(context)
          .accentColor,
    );
  }
}
