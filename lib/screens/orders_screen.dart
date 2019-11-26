import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart' show Orders;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_Item.dart';

class OrdersScreen extends StatelessWidget {
  static const orderScreenName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Page"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, i) => OrderItem(orders.orders[i]),
        itemCount: orders.orders.length,
      ),
    );
  }
}
