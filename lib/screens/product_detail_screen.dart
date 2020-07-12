import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context).settings.arguments as String;
    final dataProduct =
        Provider.of<ProductsProvider>(context).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(dataProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // Gambar Produk
            Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                dataProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // Harga Produk
            Text(
              "\$${dataProduct.price}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20
              ),
            ),

            SizedBox(height: 10),


            // Deskripsi Produk
            Text(dataProduct.description,)
          ],
        ),
      ),
    );
  }
}
