import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductGrid extends StatelessWidget {

  final isOnlyFavorite;
  ProductGrid({this.isOnlyFavorite});

  @override
  Widget build(BuildContext context) {
    // Mengambil data product dengan bantuan Provider
    final productData = Provider.of<ProductsProvider>(context);
    final loadedProducts = isOnlyFavorite ? productData.getFavoriteItems : productData.items ;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),

      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(),
      ),
    );
  }
}
