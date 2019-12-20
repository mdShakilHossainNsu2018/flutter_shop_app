import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/splash_screen.dart';
import 'package:flutter_shop_app/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              builder: (context, auth, preProducts) =>
                  Products(auth.token,
                      auth.userId,
                      preProducts == null ? [] : preProducts.items)),
          ChangeNotifierProxyProvider<Auth, Orders>(
//            create: (_) => Orders(),
            update: (_, auth, preOrders) =>
                Orders(auth.token, auth.userId,
                    preOrders == null ? [] : preOrders.orders),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
//          ChangeNotifierProvider.value(
//            value: Orders(),
//          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) =>
              MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primarySwatch: Colors.purple,
                    accentColor: Colors.deepOrange,
                    fontFamily: 'Lato'),
                home: auth.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, autoLoginSnapshot) =>
                    autoLoginSnapshot.connectionState ==
                        ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen()),
                routes: {
                  ProductDetailScreen.productDetailRouteName: (ctx) =>
                      ProductDetailScreen(),
                  CartScreen.cartScreenName: (context) => CartScreen(),
                  OrdersScreen.orderScreenName: (context) => OrdersScreen(),
                  UserProductScreen.userProductScreenName: (context) =>
                      UserProductScreen(),
                  EditProductScreen.routeName: (context) => EditProductScreen(),
                },
              ),
        ));
  }
}
