import 'package:flutter/material.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/mainDrawer.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = "/userProductsScreen";
  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future _myproductsFuture;
  Future obtainMyProductsFuture() {
    var token = Provider.of<Auth>(context, listen: false).getToken;
    return Provider.of<ProductsProvider>(context, listen: false)
        .fetchMyProducts(token);
  }

  @override
  void initState() {
    _myproductsFuture = obtainMyProductsFuture();
    super.initState();
  }

  Future<void> refreshPage(BuildContext context) async {
    _myproductsFuture = obtainMyProductsFuture();
  }

  @override
  Widget build(BuildContext context) {
    var productsData = Provider.of<ProductsProvider>(context);
    var products = productsData.myItems;
    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
      ),
      appBar: AppBar(
        title: Text(
          "My Products",
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshPage(context),
        child: FutureBuilder(
            future: _myproductsFuture,
            builder: (context, dataSnapshot) {
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
                  return Container(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: products.length,
                        itemBuilder: (ctx, i) => Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(products[i].imageUrl),
                                    radius: 35,
                                  ),
                                  title: Text(products[i].title),
                                  trailing: Container(
                                    width: 200,
                                    child: ButtonBar(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                  EditProductScreen.routeName,
                                                  arguments: products[i].id);
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Theme.of(context).errorColor,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Are you sure?",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: Text(
                                                          "Do you want to delete the Product Permanently?"),
                                                      actions: [
                                                        RaisedButton(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            child: Text(
                                                              "No",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6,
                                                            )),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        RaisedButton(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true),
                                                            child: Text("Yes",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6))
                                                      ],
                                                    );
                                                  }).then((value) {
                                                if (value == true) {
                                                  productsData.deleteProduct(
                                                      products[i].id,
                                                      Provider.of<Auth>(context,
                                                              listen: false)
                                                          .getToken);
                                                }
                                              });
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            )),
                  );
                }
              }
            }),
      ),
    );
  }
}
