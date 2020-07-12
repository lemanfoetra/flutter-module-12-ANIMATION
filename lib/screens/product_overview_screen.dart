import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../providers/chart_provider.dart';
import '../providers/product_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreeen extends StatefulWidget {
  @override
  _ProductOverviewScreeenState createState() => _ProductOverviewScreeenState();
}

class _ProductOverviewScreeenState extends State<ProductOverviewScreeen> {
  bool onlyFavorite = false;
  bool isInit = true;

  // _isloading untuk mengaktifkan loading indicator
  bool _isloading = false;
  bool _isError = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      
        setState(() {
          _isloading = true;
        });
        var productPv = Provider.of<ProductsProvider>(context);
        productPv.getListProduct().catchError((_){
          _isError = true;
        }).then((_) {
          setState(() {
            _isloading = false;
          });
        }).catchError((erro){
          _isError = true;
        });
    }

    isInit = false;
    super.didChangeDependencies();
  }

  void setOnlyFavorite(bool status) {
    setState(() {
      onlyFavorite = status;
    });
  }

  void toChartScreen(BuildContext context) {
    Navigator.of(context).pushNamed(CartScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final chart = Provider.of<ChartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          // Menu Badge Chart
          Consumer<ChartProvider>(
            builder: (ctx, _, ch) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  toChartScreen(context);
                },
              ),
              value: chart.totalChart.toString(),
            ),
          ),

          // Menu untuk memfilter List Product
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Tampilkan Favorit'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Semua'),
                value: FilterOptions.All,
              )
            ],
            onSelected: (FilterOptions filterOption) {
              if (filterOption == FilterOptions.Favorites) {
                setOnlyFavorite(true);
              } else {
                setOnlyFavorite(false);
              }
            },
          )
        ],
      ),
      drawer: AppDrawers(),
      body: _isError
          ? Center(child: Text('Terjadi Kesalahan Jaringan'))
          : _isloading
              ? Center(child: CircularProgressIndicator())
              : ProductGrid(
                  isOnlyFavorite: onlyFavorite,
                ),
    );
  }
}
