import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/product_item_widget.dart';
import '../providers/productItem_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_items_provider.dart';
import '../widgets/mainDrawer.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future _productsFuture;
  Future obtainProductsFuture() {
   var token= Provider.of<Auth>(context, listen: false).getToken;
    return Provider.of<ProductsProvider>(context, listen: false)
        .fetchProduct(token);
  }

  @override
  void initState() {
    _productsFuture = obtainProductsFuture();
    super.initState();
  }

  bool onlyFav = false;

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<ProductsProvider>(context);
    var products = onlyFav ? productsData.favItems : productsData.items;
    return Scaffold(
        drawer: Drawer(
          child: MainDrawer(),
        ),
        appBar: AppBar(
          title: Text(
            onlyFav ? "Favourites" : "Products",
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              icon:
                  onlyFav ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              onPressed: () {
                setState(() {
                  onlyFav = !onlyFav;
                });
              },
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: FutureBuilder(
            future: _productsFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text("Some Error Occured"),
                  );
                } else {
                  return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2.8 / 1,
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (ctx, i) =>
                          ProductItemWIdget(products[i], productsData));
                }
              }
            }));
  }
}
