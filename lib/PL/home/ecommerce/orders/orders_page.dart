import 'package:all/PL/widgets/constant.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ecommerce_constants.dart';
import 'order_card.dart';
class OrdersPage extends StatelessWidget {

  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EcommerceProvider ecommerceProvider=Provider.of<EcommerceProvider>(context);

    return  SafeArea(
      child:  Column(children: [
          const SizedBox(height: 10),
          _dataWidget(ecommerceProvider),
        ],),
    );}

  _dataWidget(EcommerceProvider ecommerceProvider){
    return Expanded(child:RefreshIndicator(
        onRefresh: ()async{
      await ecommerceProvider.loadEcommerceList("in");

    },
    child:ecommerceProvider.isLoading
        ?
    Align(alignment: Alignment.topCenter,child:loadingWidget2())
        :
    ecommerceProvider.ordersList.isEmpty
        ?
    noDataCard(text: "انت لم تقم بأي طلبات حتي الان",icon: Icons.shopping_basket)
        :
    SizedBox(
      child:
        ListView.builder(
          itemCount:ecommerceProvider.ordersList.length,
          itemBuilder: (context,position) {
            return OrderCard(model: ecommerceProvider.ordersList[position],
                  ecommerceProvider: ecommerceProvider);
          }

      )),
    ));
  }

}