import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // buat form key agar form diketahui flutter
  final _formKey = GlobalKey<FormState>();
  final _focusPrice = FocusNode();
  final _focusNodeDescription = FocusNode();
  final _imgUrlController = TextEditingController();

  String _productId;
  String _title = '';
  String _description = '';
  String _price = '';
  String _imgUrl = '';
  bool _isFavorite = false;

  bool isInputUrlImage = false;
  bool onFirstDipLoad = true;
  Product _productData;

  bool _loadingIsOpen = false;

  // FUNCTION
  Future<void> _simpanForm(BuildContext scaffoldContext) async {
    // Deklarasikan ini agar validate berjalan
    bool isValid = _formKey.currentState.validate();
    if (isValid) {
      // untuk menyimpan form
      _formKey.currentState.save();

      _productData = Product(
        id: _productId,
        title: _title,
        description: _description,
        price: double.parse(_price),
        imageUrl: _imgUrl,
        isFavorite: _isFavorite,
      );

      // Add or Edit Product
      setState(() {
        _loadingIsOpen = true;
      });

      if (_productId == null) {
        // Add product
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_productData);
        } catch (error) {
          await showDialogError(context);
        }

        // Edit product
      } else {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .editProduct(_productId, _productData);
        } catch (error) {
          await showDialogError(context);
        }
      }

      setState(() {
        _loadingIsOpen = false;
      });
      Navigator.of(context).pop();
    }
  }

  // WIDGET
  // dialog ketika terjadi error
  Future<void> showDialogError(BuildContext contextt) async {
    await showDialog(
      context: contextt,
      builder: (ctx) => AlertDialog(
        content:
            Text("Up ada yang salah :("), // sebaiknya pesan error di custom
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // WIDGET
  // ketika melaod image
  Widget _onLoadImage(loadingProgress) {
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
            : null,
      ),
    );
  }

  // WIDGET
  // void _munculkanSnackBar(BuildContext context, String title) {
  //   Scaffold.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(title),
  //       duration: Duration(seconds: 3),
  //     ),
  //   );
  // }

  // dispose() dijalankan ketika state widget dihancurkan
  @override
  void dispose() {
    // focus node dihancurkan agar tidak terjadi kebocoran memmory
    _focusPrice.dispose();
    _focusNodeDescription.dispose();
    _imgUrlController.dispose();

    super.dispose();
  }

  // Difungsikan Ketika Update Product
  @override
  void didChangeDependencies() {
    if (onFirstDipLoad) {
      var productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _productData =
            Provider.of<ProductsProvider>(context).findById(productId);
        _imgUrlController.text = _productData.imageUrl;
        _title = _productData.title;
        _description = _productData.description;
        _price = _productData.price.toString();
        _isFavorite = _productData.isFavorite;
        _productId = _productData.id;
      }
    }

    onFirstDipLoad = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext scaffoldContext) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _simpanForm(scaffoldContext),
            ),
          ),
        ],
      ),
      body: _loadingIsOpen
          // indikator loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // untuk title
                      TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,

                        // Ketika tombol enter ditekan
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_focusPrice);
                        },
                        // bisa gunakan onSaved() untuk menyimpan datanya ketika di submit
                        onSaved: (value) {
                          _title = value;
                        },

                        // gunakan validator untuk validasi. return null = true, return string = false
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Title Perlu Disi";
                          }
                          return null;
                        },
                      ),

                      // untuk price (harga)
                      TextFormField(
                        decoration: InputDecoration(labelText: "Price"),
                        initialValue: _price,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType
                            .number, // Untuk meng set type Input keyboard
                        focusNode: _focusPrice,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodeDescription);
                        },
                        // bisa gunakan onSaved() untuk menyimpan datanya ketika di submit
                        onSaved: (value) {
                          if (value.isEmpty) {
                            _price = '';
                          } else {
                            _price = value;
                          }
                        },

                        validator: (value) {
                          if (value.isEmpty) {
                            return "Price perlu diisi.";
                          }
                          return null;
                        },
                      ),

                      // unutk deskripsi
                      TextFormField(
                        decoration: InputDecoration(labelText: "Description"),
                        initialValue: _description,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3, // berarti 3 baris
                        focusNode: _focusNodeDescription,
                        // bisa gunakan onSaved() untuk menyimpan datanya ketika di submit
                        onSaved: (value) {
                          _description = value;
                        },

                        validator: (value) {
                          if (value.isEmpty) {
                            return "Description Perlu diisi";
                          }
                          return null;
                        },
                      ),

                      // untuk gambar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 15),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: !isInputUrlImage
                                ? Center(
                                    child: Text('No Image'),
                                  )
                                : Image.network(
                                    _imgUrlController.text,
                                    fit: BoxFit.cover,

                                    // menampilkan loading ketika image dimuata
                                    loadingBuilder:
                                        (ctx, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return _onLoadImage(loadingProgress);
                                      }
                                    },
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              controller: _imgUrlController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (isi) {
                                setState(() {
                                  if (_imgUrlController.text.isEmpty) {
                                    isInputUrlImage = false;
                                  } else {
                                    isInputUrlImage = true;
                                  }
                                });
                              },

                              // bisa gunakan onSaved() untuk menyimpan datanya ketika di submit
                              onSaved: (value) {
                                _imgUrl = value;
                              },

                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Image perlu diisi.";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
