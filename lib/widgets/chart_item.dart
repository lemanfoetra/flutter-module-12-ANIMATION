import 'package:flutter/material.dart';

class ChartItem extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final double quantity;

  ChartItem({this.id, this.price, this.title, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('\$ $price'),
              ),
            ),
          ),
          title: Text(title),
          trailing: Text(" $quantity X"),
          subtitle: Text("Total = ${(price * quantity)}"),
        ),
      ),
    );
  }
}
