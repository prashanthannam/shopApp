import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart_items_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final String itemKey;
  CartItemWidget(this.item, this.itemKey);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(itemKey),
      background: Container(
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeAllFromCart(itemKey);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?",textAlign: TextAlign.center,),
                  content: Text("Do you want to delete the item from Cart?"),
                  
                  actions: [
                    RaisedButton(color: Theme.of(context).accentColor, onPressed: ()=>Navigator.of(context).pop(false), child: Text("No",style: Theme.of(context).textTheme.headline6,)),
                    SizedBox(width: 20,),
                    RaisedButton(color: Theme.of(context).accentColor,onPressed: ()=>Navigator.of(context).pop(true), child: Text("Yes",style: Theme.of(context).textTheme.headline6))
                  ],
                ));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(
                "₹ ${(item.price * item.count).toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.headline6,
              ),
              ButtonBar(
                children: [
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      cart.removeFromCart(itemKey);
                    },
                    child: Text(
                      "-",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      item.count.toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      cart.addToCart(itemKey, item.title, item.price);
                    },
                    child: Text(
                      "+",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
