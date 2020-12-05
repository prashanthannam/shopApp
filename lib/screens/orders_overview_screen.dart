import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/widgets/order_item_widget.dart';
import '../widgets/mainDrawer.dart';
import 'package:shopapp/providers/orders_provider.dart';

class OrdersOverviewScreen extends StatefulWidget {
  static const routeName = "/ordersScreen";

  @override
  _OrdersOverviewScreenState createState() => _OrdersOverviewScreenState();
}

class _OrdersOverviewScreenState extends State<OrdersOverviewScreen> {
  Future _ordersFuture;
  Future obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders(Provider.of<Auth>(context, listen: false).getToken);
  }

  @override
  void initState() {
    _ordersFuture = obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: FutureBuilder(
          future: _ordersFuture,
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
                
                return orders.orders.length==0? Center(child: Text("No Orders yet!!"),):Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemBuilder: (context, index) {
                          return OrderItemWidget(orders.orders[index]);
                        },
                        itemCount: orders.orders.length,
                      ))
                    ],
                  ),
                );
              }
            }
          }),
    );
  }
}
