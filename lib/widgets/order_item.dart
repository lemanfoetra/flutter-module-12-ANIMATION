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
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isExpanded
          ? (60 * widget.order.chartItem.length).toDouble() + 90
          : 90,
      child: Card(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("\$${widget.order.amount} "),
              subtitle: Text(
                DateFormat('mm-dd-yyyy (hh:mm)')
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
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded
                  ? (60 * widget.order.chartItem.length).toDouble()
                  : 0,
              padding: EdgeInsets.only(left: 30),
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
      ),
    );
  }
}
