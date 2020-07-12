import 'package:flutter/material.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imgUrl;

  UserProductItem({this.productId, this.title, this.imgUrl});

  @override
  Widget build(BuildContext context) {

    // bikin scaffold object
    final scaffold = Scaffold.of(context);
    
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProductScreen.routeName,
                        arguments: productId);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context)
                          .deleteProduct(productId);
                    } catch (error) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
