import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/productItem_provider.dart';
import 'package:shopapp/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProductScreen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  var _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null, title: null, description: null, price: null, imageUrl: null);
  var _isInit = true;
  var _isLoading = false;
  saveForm() {
    var _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id == null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct,
              Provider.of<Auth>(context, listen: false).getToken)
          .catchError((value) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text("Something went Wrong!"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("Okay"),
              ),
            ],
          ),
        );
      }).then((_) {
        Provider.of<ProductsProvider>(context, listen: false).fetchMyProducts(
            Provider.of<Auth>(context, listen: false).getToken);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .editProduct(_editedProduct,
              Provider.of<Auth>(context, listen: false).getToken)
          .then((value) {
        Provider.of<ProductsProvider>(context, listen: false).fetchMyProducts(
            Provider.of<Auth>(context, listen: false).getToken);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void initState() {
    _imageUrlFocus.addListener(() {
      if (!_imageUrlFocus.hasFocus) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct =
            Provider.of<ProductsProvider>(context).getProductByID(id);
        print(_editedProduct);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(_editedProduct.id == null ? "Add Product" : "Edit Product"),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: _editedProduct.title,
                          decoration: InputDecoration(labelText: "Title"),
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter Valid Titile";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _editedProduct.price == null
                              ? ""
                              : _editedProduct.price.toString(),
                          decoration: InputDecoration(labelText: "Price"),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter Price";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please Enter valid Price";
                            }
                            if (double.parse(value) <= 0) {
                              return "Please Enter valid Price";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _editedProduct.description,
                          decoration: InputDecoration(labelText: "Description"),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite,
                            );
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter Valid Description";
                            }
                            return null;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: 100,
                                height: 100,
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: _imageUrlController.text.isEmpty
                                    ? Text("Enter Url")
                                    : FittedBox(
                                        child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocus,
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: _imageUrlController.text,
                                    isFavourite: _editedProduct.isFavourite,
                                  );
                                },
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (_imageUrlController.text.isEmpty) {
                                    return "Please Enter Image URL";
                                  }
                                  if (!_imageUrlController.text
                                          .startsWith("http") &&
                                      !_imageUrlController.text
                                          .startsWith("https")) {
                                    return "Please Enter Valid Image URL";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: 50,
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              saveForm();
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )),
              ));
  }
}
