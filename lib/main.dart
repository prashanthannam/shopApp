import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart_items_provider.dart';
import 'package:shopapp/providers/orders_provider.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_overview_screen.dart';
import 'package:shopapp/screens/product_description_screen.dart';
import 'package:shopapp/screens/products_overview_screen.dart';
import 'package:shopapp/screens/splash_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

import 'providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders())
      ],
      child: Consumer<Auth>(builder: (ctx,auth,_)=>MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Color.fromRGBO(215, 71, 73, 1),
            fontFamily: "Lato"),
        home: auth.isAuth? ProductsScreen():FutureBuilder(future: auth.autoLogin(),builder: (ctx,auth,)=>
        auth.connectionState==ConnectionState.waiting? SplashScreen():AuthScreen()),
        // initialRoute: "/",
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ProductDetScreen.routeName: (ctx) => ProductDetScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersOverviewScreen.routeName: (ctx) => OrdersOverviewScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),) 
    );
  }
}
