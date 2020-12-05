import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart_items_provider.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductDetScreen extends StatelessWidget {
  static const routeName = "/productdetscreen";

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .getProductByID(id);
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          iconTheme: IconThemeData(color: Colors.black),
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(product.title,style: TextStyle(backgroundColor: Colors.black54,fontSize: 30),),
            background: Hero(
              tag: product.id,
              child: Image(
                image: NetworkImage(product.imageUrl),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 20,
          ),
          Text(
            "₹ ${product.price}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[800], fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            product.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child:
                Provider.of<Cart>(context).particularItemCount(product.id) == 0
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () => cart.addToCart(
                              product.id, product.title, product.price),
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      )
                    : ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              cart.removeFromCart(product.id);
                            },
                            child: Icon(Icons.delete),
                          ),
                          FittedBox(
                            child: Text(
                              Provider.of<Cart>(context)
                                  .particularItemCount(product.id)
                                  .toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              cart.addToCart(
                                  product.id, product.title, product.price);
                            },
                            child: Icon(
                              Icons.add,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
          ),
          GestureDetector(
            onTap: (){},
            child: HStack(
                          [VStack([
                VxBox().size(30, 2).red600.make(),
                5.heightBox,
                VxBox().size(40, 2).red600.make(),
                5.heightBox,
                VxBox().size(20, 2).red600.make()
              ]).p12(),
              "erf".text.make().shimmer()]
            ),
          )
        ]))
      ],
    ));
  }
}
