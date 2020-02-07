import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import '../tabs/home_tab.dart';
import '../widgets/custom_drawer.dart';

class HomeScrean extends StatelessWidget {

  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
       Scaffold(
         body: HomeTab(),
         drawer: CustomDrawer(_pageController),
         floatingActionButton:  CartButton(),
       ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Container(color: Colors.black,),
        Container(color: Colors.white,),
      ],
    );
  }
}
