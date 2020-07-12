import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth_provider.dart';

class AppDrawers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shop App'),
            automaticallyImplyLeading: false,
          ),

          //
          Padding(
            padding: EdgeInsets.only(top: 10) ,
            child: ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ),

          //
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreeen.routeName);
            },
          ),

          //
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),

          //
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
