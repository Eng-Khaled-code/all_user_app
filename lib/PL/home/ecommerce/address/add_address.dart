
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/PL/widgets/custom_textfield.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ecommerce_constants.dart';
// ignore: must_be_immutable
class AddAddress extends StatelessWidget {

  AddAddress({Key? key, this.addressId = 0, this.country, this.phone2, this.phone1, this.postCode, this.city})
      :super(key: key);
  final int? addressId;

  String?country;

  String?city;

  String?postCode ;

  String? phone1;

  String?phone2;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    EcommerceProvider ecommerceProvider=Provider.of<EcommerceProvider>(context);
    return  Directionality(
        textDirection: TextDirection.rtl,
        child:Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppbar(context:context,title:addressId == 0 ? "تسجيل عنوان جديد" : "تعديل العنوان" ),
        body: body(context,ecommerceProvider)));
  }

  Widget body(BuildContext context,EcommerceProvider ecommerceProvider) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(key: _formKey, child:
        ecommerceProvider.isLoading
            ?
            Align(alignment:Alignment.topCenter,child:loadingWidget2()!)
        :
        _fieldsWidget(context,ecommerceProvider),)
    );
  }

  Widget _fieldsWidget(BuildContext context,EcommerceProvider ecommerceProvider) {
    return SingleChildScrollView(child: Column(children: [
      CustomTextField(
        initialValue: country,
        lable: "البلد",
        onSave: (value) {
          country = value;
        },),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: city,
        lable: "المدينة",
        onSave: (value) {
          city = value;
        },), const SizedBox(height: 15.0),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: postCode,
        lable: "الرقم البريدي",
        onSave: (value) {
          postCode = value;
        },), const SizedBox(height: 15.0),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: phone1,
        lable: "رقم التليفون",
        onSave: (value) {
          phone1 = value;
        },), const SizedBox(height: 15.0),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: phone2,
        lable: "رقم تليفون اخر",
        onSave: (value) {
          phone2 = value;
        },), const SizedBox(height: 15.0),
      CustomButton(
          color: const[
            primaryColor,
            Color(0xFF0D47A1),
          ],
          text: addressId == 0 ? "إضافة" : "تعديل",
          onPress: () async {
            _formKey.currentState
            !.save();

            if(_formKey.currentState!.validate()){
            if(await ecommerceProvider.addressOperations(type:addressId==0?"add":"update",addressId:addressId,country:country,city:city,postCode:postCode,phone1:phone1,phone2:phone2))
            {
              Navigator.pop(context);
            }
            }
          },
          textColor: Colors.white),
    ],),);
  }
}