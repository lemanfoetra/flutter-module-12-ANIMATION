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
      // appBar: AppBar(
      //   title: Text(dataProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(dataProduct.title),
              background: Container(
                height: 250,
                width: double.infinity,
                child: Hero(
                  tag: dataProduct.id,
                  child: Image.network(
                    dataProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),

              // Harga Produk
              Text(
                "\$${dataProduct.price}",
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              // Deskripsi Produk
              Text(
                dataProduct.description,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 800,),
            ]),
          )
        ],
      ),
    );
  }
}
