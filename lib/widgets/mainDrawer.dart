import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/orders_overview_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            height: 120,
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            child: Text(
              "Shop Up!",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            leading: Icon(
              Icons.shop,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Shop",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoCondensed",
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersOverviewScreen.routeName);
            },
            leading: Icon(
              Icons.receipt,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Orders",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoCondensed",
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
            leading: Icon(
              Icons.edit,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "My Products",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoCondensed",
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logOut();
            },
            leading: Icon(
              Icons.logout,
              size: 26,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Log Out",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "RobotoCondensed",
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
