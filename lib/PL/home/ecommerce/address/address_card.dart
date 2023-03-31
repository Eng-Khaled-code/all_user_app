import 'package:all/Models/ecommerce/address_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ecommerce_constants.dart';
import 'add_address.dart';

class AddressCard extends StatelessWidget {
  EcommerceProvider? ecommerceProvider;
  final AddressModel? model;
  final int? radioValue;
  AddressCard(
      {Key? key,
        this.model,
        this.radioValue,this.ecommerceProvider
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return  Column(
      children: [
        Card(
            margin:const EdgeInsets.all(8.0),
            color: Colors.lightBlueAccent,
            child: Column(
              children: [
                 _topActionRow(context),
                _columnData(screenWidth),
                 ],
            ),

        ),_orderButton(context)
      ],
    );
  }

 Column _columnData(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:const EdgeInsets.all(10),
          width: screenWidth * 0.8,
          child: Table(
            children: [
              TableRow(children: [
                CustomText(text: "البلد",color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold,alignment: Alignment.centerRight),
                Text(model!.country!)
              ]),
              TableRow(children: [
                CustomText(text: "المدينة",color: Colors.black ,fontSize: 15,fontWeight: FontWeight.bold,alignment: Alignment.centerRight),
                Text(model!.city!)
              ]),
              TableRow(children: [
                CustomText(text: "الرقم البريدي",color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,alignment: Alignment.centerRight),
                Text(model!.postCode!)
              ]),
              TableRow(children: [
                CustomText(text: "رقم التليفون",color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,alignment: Alignment.centerRight),
                Text(model!.phone1!)
              ]),
              TableRow(children: [
                CustomText(text: "رقم تليفون آخر",color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold,alignment: Alignment.centerRight),
                Text(model!.phone2!)
              ]),

            ],
          ),
        )
      ],

    );
 }

 Widget _orderButton(BuildContext context) {
    return currentAddressIndex==radioValue?Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: CustomButton(color:const[Colors.blue,Colors.blue],textColor: Colors.white,text: 'إتمام الطلب',onPress: (){
        ecommerceProvider!.orderOperations(
        type : "add",
        addressId:model!.id,
        );
        Navigator.pop(context);
      },),
    ):Container();
 }

 Row _topActionRow(BuildContext context) {
    return Row(
      children: [
        Radio<int>(
          value:radioValue!,
          groupValue:currentAddressIndex ,
          activeColor: Colors.white,
          onChanged: (value){},
        ),
        TextButton.icon(onPressed: ()async{
          goTo(context: context,to: AddAddress(
            addressId: model!.id,
            city:model!.city ,
            country:model!.country,
            postCode: model!.postCode,
            phone1:model!.phone1,
            phone2: model!.phone2,));

        }, icon:const Icon(Icons.edit_location,size:20,color: Colors.white,)
            , label: CustomText(text:"تعديل العنوان",fontSize: 12,color: Colors.white,)),
        TextButton.icon(onPressed: ()async{
          Provider.of<EcommerceProvider>(context,listen: false).addressOperations(type: "delete",addressId:model!.id );
        }, icon:const Icon(Icons.delete,size:20,color: Colors.white,)
            , label: CustomText(text:"حذف العنوان",fontSize: 12,color: Colors.white,))
      ],
    );
 }
}
