import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/products_provider.dart';
import 'package:shopapp/screens/product_description_screen.dart';
import 'package:shopapp/providers/productItem_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../providers/cart_items_provider.dart';

class ProductItemWIdget extends StatelessWidget {
  final Product product;
  final ProductsProvider productData;
  ProductItemWIdget(this.product, this.productData);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return GestureDetector(
       onTap: () => Navigator.of(context).pushNamed(
                          ProductDetScreen.routeName,
                          arguments: product.id),
          child: Container(
              // margin: const EdgeInsets.all(5),
              child: HStack(
                [
                  Container(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          ProductDetScreen.routeName,
                          arguments: product.id),
                      child: Hero(
                        tag: product.id,
                        child: Container(
                          // color: Colors.white,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.4), width: 3),
                          ),
                          child: FadeInImage(
                            fadeInCurve: Curves.decelerate,
                            placeholder:
                                AssetImage('assets/images/placeholder.png'),
                            image: NetworkImage(
                              product.imageUrl,
                            ),
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.widthBox,
                  VStack([
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: product.title.text.bold.size(30).make()),
                    10.heightBox,
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: "\₹ ${product.price}".text.xl2.gray600.semiBold.make()),
                    HStack([
                      IconButton(
                        icon: product.isFavourite
                            ? Icon(
                                Icons.favorite,
                                size: 30,
                              )
                            : Icon(
                                Icons.favorite_outline,
                                size: 30,
                              ),
                        onPressed: () {
                          productData.toggleFav(product.id,
                              Provider.of<Auth>(context, listen: false).getToken);
                        },
                        color: Theme.of(context).accentColor,
                      ),
                      IconButton(
                        icon: Icon(
                          Provider.of<Cart>(context)
                                      .particularItemCount(product.id) ==
                                  0
                              ? Icons.shopping_cart_outlined
                              : Icons.shopping_cart,
                          size: 30,
                        ),
                        onPressed: () {
                          cart.addToCart(
                              product.id, product.title, product.price);
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Item Added to Cart"),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cart.removeFromCart(product.id);
                              },
                            ),
                          ));
                        },
                        color: Theme.of(context).accentColor,
                      ),
                    ])
                  ])
                ],
              ).cornerRadius(2).backgroundColor(Vx.gray200),
            
            // header: Text(
            //   product.title,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     backgroundColor: Colors.black45,
            //     color: Colors.white,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //   ),
            // ),
            // footer: GridTileBar(
            //   leading: IconButton(
            //     icon: product.isFavourite
            //         ? Icon(Icons.favorite)
            //         : Icon(Icons.favorite_outline),
            //     onPressed: () {
            //       productData.toggleFav(product.id,
            //           Provider.of<Auth>(context, listen: false).getToken);
            //     },
            //     color: Theme.of(context).accentColor,
            //   ),
            //   backgroundColor: Colors.black54,
            //   title: Text(
            //     "\₹ ${product.price}",
            //     textAlign: TextAlign.center,
            //   ),
            //   trailing: IconButton(
            //     icon: Icon(
            //         Provider.of<Cart>(context).particularItemCount(product.id) ==
            //                 0
            //             ? Icons.shopping_cart_outlined
            //             : Icons.shopping_cart),
            //     onPressed: () {
            //       cart.addToCart(product.id, product.title, product.price);
            //       Scaffold.of(context).hideCurrentSnackBar();
            //       Scaffold.of(context).showSnackBar(SnackBar(
            //         content: Text("Item Added to Cart"),
            //         duration: Duration(seconds: 2),
            //         action: SnackBarAction(
            //           label: "UNDO",
            //           onPressed: () {
            //             cart.removeFromCart(product.id);
            //           },
            //         ),
            //       ));
            //     },
            //     color: Theme.of(context).accentColor,
            //   ),
            // ),

            
      ),
    );
  }
}
