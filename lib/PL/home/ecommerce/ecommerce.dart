import 'package:all/PL/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'ecommerce_constants.dart';
import 'orders/orders_page.dart';
import 'products/products_page.dart';
import 'shopping_cart/shoping_cart.dart';
class Ecommerce extends StatefulWidget {
  const Ecommerce({Key? key}):super(key: key);
  @override
  _EcommerceState createState() => _EcommerceState();
}

class _EcommerceState extends State<Ecommerce> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body:_loadingBody() ,
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }


  _loadingBody() {
    switch (currentIndex) {
      case 0:
        return ProductPage(page: "products_list");
      case 1:
        return ShoppingCart();
      case 2:
        return const OrdersPage();
      case 3:
        return  ProductPage(page: "fav_list");
      case 4:
        return  ProductPage(page: "black_list");

    }
  }



  Widget bottomNavigationBar() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          items: const[

            BottomNavigationBarItem(

                label: 'المنتجات',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.shopping_basket))),
            BottomNavigationBarItem(
                label: 'سلة المشتريات',
                icon: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(Icons.shopping_cart))),
            BottomNavigationBarItem(
                label:"الطلبات",
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.assignment_turned_in,))),
            BottomNavigationBarItem(
                label: 'المفضلة',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.favorite,))),
            BottomNavigationBarItem(
                label: 'القائمة السوداء',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.visibility_off,))),
          ],
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black45,
          unselectedLabelStyle: const TextStyle(color: Colors.black45,fontSize: 9),
          showUnselectedLabels: true,


        ));
  }

}
