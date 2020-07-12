import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders_provider.dart' as oiProvider;

class OrderItem extends StatefulWidget {
  final oiProvider.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${widget.order.amount} "),
            subtitle: Text(
              DateFormat('mm-dd-yyyy (hh:mm:ss)')
                  .format(widget.order.time)
                  .toString(),
            ),
            trailing: IconButton(
              icon: isExpanded
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),

          // Detail Product in cart
          if (isExpanded)
            Container(
              padding: EdgeInsets.only(left: 30),
              height: (80 * widget.order.chartItem.length).toDouble(),
              child: ListView.builder(
                itemCount: widget.order.chartItem.length,
                itemBuilder: (ctx, i) {
                  var chartItemData = widget.order.chartItem[i];
                  return Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        title: Text(chartItemData.title),
                        subtitle: Text(
                            "\$ ${chartItemData.price} x ${chartItemData.quantity.toStringAsFixed(0)}"),
                        onTap: () {},
                      ),
                    ],
                  );
                },
              ),
            ),


        ],
      ),
    );
  }
}
