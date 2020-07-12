import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart' show OrdersProvider;
import '../widgets/order_item.dart';

class OrdersScreeen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('Your Order')),
        body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false)
              .getOrderData(),
          builder: (ctx, snapShoot) {
            if (snapShoot.connectionState == ConnectionState.waiting) {
              // ketika loading
              return Center(child: CircularProgressIndicator());
            } else if (snapShoot.error != null) {
              // ketika error
              return Center(
                child: Text('Terjadi Kesalahan jaringan.'),
              );
            } else {
              // ketika semua baik baik saja
              return Consumer<OrdersProvider>(
                builder: (ctx, ordersData, child) => ListView.builder(
                  itemCount: ordersData.order.length,
                  itemBuilder: (ctx, i) => OrderItem(ordersData.order[i]),
                ),
              );
            }
          },
        ));
  }
}
