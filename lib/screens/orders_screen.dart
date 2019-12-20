import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/orders.dart' show Orders;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_Item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const orderScreenName = '/orders';

//  @override
//  Widget build(BuildContext context) {
//    print('building orders');
//    // final orderData = Provider.of<Orders>(context);
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Your Orders'),
//      ),
//      drawer: AppDrawer(),
//      body: FutureBuilder(
//        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
//        builder: (ctx, dataSnapshot) {
//          if (dataSnapshot.connectionState == ConnectionState.waiting) {
//            return Center(child: CircularProgressIndicator());
//          } else {
//            if (dataSnapshot.error != null) {
//              // ...
//              // Do error handling stuff
//              return Center(
//                child: Text('An error occurred!'),
//              );
//            } else {
//              return Consumer<Orders>(
//                builder: (ctx, orderData, child) => ListView.builder(
//                  itemCount: orderData.orders.length,
//                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
//                ),
//              );
//            }
//          }
//        },
//      ),
//    );
//  }
//}
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Page"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
          Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An Error Occure'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orders, child) =>
                      ListView.builder(
                        itemBuilder: (context, i) =>
                            OrderItem(orders.orders[i]),
                        itemCount: orders.orders.length,
                      ),
                );
              }
            }
          },
        ));
  }
}
