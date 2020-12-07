import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/orders_provider.dart';
import '../providers/cart_items_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = new Razorpay();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var orders = Provider.of<Orders>(context);
    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      print(response.orderId.toString()+" "+response.paymentId.toString()+" "+response.signature.toString());
      orders
          .addOrder(cart.totAmount, cart.items.values.toList(),
              Provider.of<Auth>(context, listen: false).getToken)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        // cart.clear();
      });
       Toast.show("Payment Successfull "+response.paymentId, context,duration: Toast.LENGTH_LONG,backgroundColor: Colors.green,gravity: Toast.TOP);

    }

    void _handlePaymentError(PaymentFailureResponse response) {
      setState(() {
              _isLoading = false;
      });
      Toast.show(response.message, context,duration: Toast.LENGTH_LONG,gravity: Toast.TOP,backgroundColor: Colors.red);
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      print("P"+response.toString());
    }

    void openCheckout() async {
      print("erftg");
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
      var options = {
        'key': 'rzp_test_glA246D8rCFOVc',
        'amount': cart.totAmount*100,
        'name': 'Acme Corp.',
        'description': 'Fine T-Shirt',
        'prefill': {
          'contact': '8466851979',
          'email': 'prashanth31399@gmail.com'
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: cart.items.keys.length == 0
                  ? Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        "Cart is Empty!!",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    )
                  : ListView.builder(
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
                        print("qwerf");
                        openCheckout();
                        // orders
                        //     .addOrder(
                        //         cart.totAmount, cart.items.values.toList(),Provider.of<Auth>(context, listen: false).getToken)
                        //     .then((value) {
                        //       setState(() {
                        //   _isLoading = false;
                        //       });
                        //   cart.clear();
                        // });
                      },
                child: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(
                        "Order Now",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline5
                                .color),
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
