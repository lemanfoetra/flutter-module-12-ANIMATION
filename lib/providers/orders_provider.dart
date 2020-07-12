import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/chart_provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final DateTime time;
  final List<ChartItem> chartItem;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.time,
      @required this.chartItem});
}

class OrdersProvider with ChangeNotifier {
  final String userId;
  final String authToken;
  List<OrderItem> _order = [];

  // construct
  OrdersProvider(this.authToken, this.userId);

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> getOrderData() async {
    final url =
        "https://flutter-shopapps.firebaseio.com/orders/$userId.json?auth=$authToken";
    final List<OrderItem> orderLoaded = [];
    final response = await http.get(url);
    final extraxData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxData != null) {
      extraxData.forEach((key, value) {
        orderLoaded.add(OrderItem(
          id: key,
          amount: value['amount'],
          time: DateTime.parse(value['time']),
          chartItem: (value['chartItem'] as List<dynamic>)
              .map(
                (isi) => ChartItem(
                    id: isi['id'],
                    title: isi['title'],
                    quantity: isi['quantity'],
                    price: isi['price']),
              )
              .toList(),
        ));
      });
    }

    _order = orderLoaded;
    notifyListeners();
  }

  Future<void> addOrder(List<ChartItem> chartItem, double total) async {
    final url =
        "https://flutter-shopapps.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'time': timestamp.toIso8601String(),
        'chartItem': chartItem
            .map((ci) => {
                  'id': ci.id,
                  'price': ci.price,
                  'title': ci.title,
                  'quantity': ci.quantity,
                })
            .toList(),
      }),
    );

    _order.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            chartItem: chartItem,
            time: DateTime.now()));
    notifyListeners();
  }
}
