import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../courses/courses_const.dart';

String? ecommerceSelectedCategory;
List ecommerceCategoriesList=[];
int currentAddressIndex=0;
int currentIndex = 0;



Widget _categoryItem({String? text,Function? onTap ,String? listType}) {

  Color selectedColor =
  ecommerceSelectedCategory == text ? primaryColor : Colors.transparent;

  return InkWell(
      onTap: (){

        if(listType=="ecommerce"){
        ecommerceSelectedCategory=text;
        }else
          {
            courseSelectedCategory=text;
          }
        onTap!();},
      child: Container(margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: selectedColor),
          padding: const EdgeInsets.all(5),
          child: CustomText(text: text!,
            color: selectedColor == primaryColor
                ? Colors.white
                : primaryColorDark,)
      ));
}

Widget categoryWidgets({Function? onTap,String? listType="ecommerce"}) =>
    SizedBox(
      width: double.infinity,
      height: 45,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listType=="ecommerce"?ecommerceCategoriesList.length:courseCategoriesList.length,
          itemBuilder: (context, position) =>
              _categoryItem(listType: listType,text: listType=="ecommerce"?ecommerceCategoriesList[position]:courseCategoriesList[position],onTap:()=> onTap!()),
    ));


  loadingWidget2() {
    return Container(margin:const EdgeInsets.all(50),height:20,width:20,child:const CircularProgressIndicator(strokeWidth: 2,));
  }

