import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/widgets/chart_item.dart';

class ChartItem {
  final String id;
  final String title;
  final double quantity;
  final double price;

  ChartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class ChartProvider with ChangeNotifier {
  Map<String, ChartItem> _items = {};

  Map<String, ChartItem> get items {
    return {..._items};
  }

  int get totalChart {
    return _items != null ? _items.length : 0;
  }

  void addChart(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingData) => ChartItem(
            id: existingData.id,
            price: existingData.price,
            title: existingData.title,
            quantity: existingData.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => ChartItem(
            id: DateTime.now().toString(),
            price: price,
            title: title,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, chartItem) {
      total += chartItem.price * chartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
  

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (currentItem) => ChartItem(
          id: currentItem.id,
          price: currentItem.price,
          title: currentItem.title,
          quantity: currentItem.quantity - 1,
        ),
      );
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }
}
