import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ecommerce_constants.dart';
import 'add_address.dart';
import 'address_card.dart';
class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    double screenHeight=MediaQuery.of(context).size.height;
    EcommerceProvider ecommerceProvider=Provider.of<EcommerceProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:customAppbar(context:context,title: "إختر عنوان للشحن"),
        body:_body(screenHeight,ecommerceProvider),
        floatingActionButton: _floatingButton(context)
      ),
    );


  }

  Widget _body(double screenHeight,EcommerceProvider ecommerceProvider) {
    return ecommerceProvider
    .isLoading
    ?
    Align(alignment:Alignment.topCenter,child:loadingWidget2()!)
        :
    ecommerceProvider.addressList.isEmpty
    ?
    noDataCard(text: "لا توجد عناوين شحن",icon: Icons.not_listed_location)
        :
    ListView.builder(
    itemCount: ecommerceProvider.addressList.length,
    itemBuilder: (context, position) {
    return InkWell(
    onTap: ()=> setState(()=> currentAddressIndex=position)
    ,
    child:AddressCard(model:ecommerceProvider.addressList[position] ,radioValue: position,ecommerceProvider: ecommerceProvider,));
    });

  }

  FloatingActionButton _floatingButton(BuildContext context) {
    return FloatingActionButton.extended(onPressed: (){
      goTo(context: context,to: AddAddress(addressId: 0));
    },icon:const Icon(Icons.add_location),label: CustomText(text:"إضافة عنوان",color: Colors.white,),);

  }
}
