import 'package:flutter/material.dart';
import 'package:shop/widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';

  // Mengambil kembali data ketika halaman di refresh
  Future<void> _refreshHalaman(BuildContext context) async {
    var productData = Provider.of<ProductsProvider>(context, listen: false);
    await productData.getListProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductsProvider>(context);
    // print('builldd');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawers(),
      body: FutureBuilder(
        future: _refreshHalaman(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Loading error!'));
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshHalaman(context),
              child: Consumer<ProductsProvider>(
                builder: (ctx, productData, _) => Container(
                  child: ListView.builder(
                    itemCount: productData.items.length,
                    itemBuilder: (ctx, i) {
                      return UserProductItem(
                        imgUrl: productData.items[i].imageUrl,
                        productId: productData.items[i].id,
                        title: productData.items[i].title,
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
