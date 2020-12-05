import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/orders_provider.dart';
import '../providers/cart_items_provider.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: cart.items.keys.length==0?
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top:50),
          child: Text("Cart is Empty!!",style: Theme.of(context).textTheme.headline4,),)
        :ListView.builder(
                itemBuilder: (context, index) {
                  return CartItemWidget(cart.items.values.toList()[index],
                      cart.items.keys.toList()[index]);
                },
                itemCount: cart.items.length,
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).accentColor,
                      label: Text(
                        "₹  ${cart.totAmount.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerRight,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: cart.items.length == 0
                    ? null
                    : () {
                      setState(() {
                        _isLoading = true;
                      });
                        orders
                            .addOrder(
                                cart.totAmount, cart.items.values.toList(),Provider.of<Auth>(context, listen: false).getToken)
                            .then((value) {
                              setState(() {
                          _isLoading = false;
                              });
                          cart.clear();
                        });
                      },
                child: _isLoading? Padding(
                  padding: const EdgeInsets.all(4),
                  child: CircularProgressIndicator(strokeWidth: 2))
                :Text(
                  "Order Now",
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.headline5.color),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
