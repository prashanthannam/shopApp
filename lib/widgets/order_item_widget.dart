import 'package:flutter/material.dart';
import 'package:shopapp/providers/orders_provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget>
    with SingleTickerProviderStateMixin {
  bool showDet = false;
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<double> _opacityReverseAnimation;

  Animation<Offset> _slideAnimation;
  @override
  void initState() {
    // TODO: implement initState
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimation = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _opacityReverseAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        // height: showDet?min(widget.order.products.length * 25.0+40, 300):400,
        padding: const EdgeInsets.all(5),
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if(!showDet)

                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: Chip(
                          backgroundColor: Colors.cyan,
                          label: Text(
                            "₹ ${widget.order.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Date : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          Text(
                            DateFormat("dd MMM yyyy")
                                .format(widget.order.dateTime),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),]),
                          Row(
                            children: [
                              Text(
                                "Time : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.black),
                              ), 
                          Text(
                            DateFormat("hh : mm aa")
                                .format(widget.order.dateTime),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(showDet ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        showDet = !showDet;
                        showDet ? _controller.forward() : _controller.reverse();
                      });
                    },
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: Row(
                        children: [
                          Text(
                            "Order ID : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          Text(
                            widget.order.id,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      constraints: BoxConstraints(
                          minHeight: showDet
                              ? widget.order.products.length * 25.0 + 10
                              : 10,
                          maxHeight: showDet
                              ? widget.order.products.length * 25.0 + 20
                              : 10),
                      // height: showDet
                      //     ? min(, 10)
                      //     : 0,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      widget.order.products[index].title,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  Text(
                                    " ${widget.order.products[index].count} x ₹ ${widget.order.products[index].price}",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ]),
                          );
                        },
                        itemCount: widget.order.products.length,
                      ),
                    ),
                    if (showDet) Divider(),
                    // if (showDet)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      constraints: BoxConstraints(
                          minHeight: showDet ? 60 : 0,
                          maxHeight: showDet ? 120 : 0),
                      child: FadeTransition(
                        opacity: _opacityReverseAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "Total",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Chip(
                                  backgroundColor: Colors.cyan,
                                  label: Text(
                                    "₹ ${widget.order.amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
