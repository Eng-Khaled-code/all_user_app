import 'package:all/PL/home/ecommerce/address/address.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../ecommerce_constants.dart';
import 'cart_card.dart';

class ShoppingCart extends StatefulWidget {
  @override
  ShoppingCartState createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCart> {


  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    EcommerceProvider ecommerceProvider=Provider.of<EcommerceProvider>(context);

  return SafeArea(
      child:  
      ecommerceProvider.isLoading
          ?
      Padding(padding:const EdgeInsets.all(50) ,child:loadingWidget2())
        :
    ecommerceProvider.cartList.isEmpty
    ?
    noDataCard(text: "سلة المشتريات فارغة",icon: Icons.remove_shopping_cart)
        :Column(
        children: [
          const SizedBox(height: 10),
           _dataWidget(ecommerceProvider),
          _bottomWidget(screenHeight*0.1,ecommerceProvider)

        ],
      ),
    );
  }

  _dataWidget(EcommerceProvider ecommerceProvider){
    return
    Expanded(
      child: SizedBox(
        child:
        ListView.builder(
            itemCount:ecommerceProvider.cartList.length,
            itemBuilder: (context,position) {
              return CartCard(model: ecommerceProvider.cartList[position],
                  ecommerceProvider: ecommerceProvider);
            }

        ),
      ),
    );
  }

  _bottomWidget(double height,EcommerceProvider ecommerceProvider) {
    return Container(
        height:height,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18)),
            boxShadow: [BoxShadow(color: Colors.blue, spreadRadius: 1.0)]),
        padding:const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              "الكمية\n ${ecommerceProvider.itemCount}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Text(
              "الاجمالي\n ${ecommerceProvider.totalPrice.toStringAsFixed(1)}\$",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: SizedBox(
                height: 45,
                child: FlatButton(
                  onPressed: () async {

                    if (ecommerceProvider.itemCount==0) {
                      Fluttertoast.showToast(msg: "your cart is empty");
                    } else {

                      goTo(context: context,to:Address());
                    }
                  },
                  child: const Text(
                    "شراء",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,),
                  ),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
          ],
        ));
  }
}
