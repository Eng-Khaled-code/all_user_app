import 'package:all/Models/ecommerce/cart_model.dart';
import 'package:all/Models/ecommerce/order_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  final OrderModel? model;
  EcommerceProvider? ecommerceProvider;

  OrderCard({Key? key,this.model,this.ecommerceProvider}):super(key: key);

  @override
  Widget build(BuildContext context){
    return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: customDecoration(color: Colors.blue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _topRow(),
              _dataRow(context),
               _itemsList(),
               _checkEdit(model!.orderCartList!)?
               _deleteButton(context)
                   :Container()
    ],

      ),
    );
  }

  Padding _itemsList(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 330,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model!.orderCartList!.length,
            itemBuilder: (context,position){
              return _itemCart(CartModel.fromSnapshot(model!.orderCartList![position]));

            }),
      ),
    );
}

  Container _itemCart(CartModel model){
    return Container(
      width: 220,
      margin:const EdgeInsets.only(left: 10) ,
      padding:const EdgeInsets.all( 5)  ,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminProfileWidget(image:model.adminImage!,name:model.productAdmin!,date:""),
        const SizedBox(height: 5),
        imageWidget(image:model.productImage!,height: 120),
        CustomText(text: model.productName!+"\n"+"سعر الوحدة : ${model.itemPrice}"+"\n"+"الكمية : ${model.itemCount}"+"\n"+"السعر الكلي : ${model.totalPrice}",alignment: Alignment.centerRight,textAlign: TextAlign.right,fontWeight: FontWeight.bold,maxLine: 5,),
        CustomText(text:model.cartStatus==0?"لم يتم الرد علي طلبك":model.cartStatus==1?"تمت الموافقة وسيتم التواصل معك":"تم رفض هذا المنتج",alignment: Alignment.centerRight,textAlign: TextAlign.right,color:model.cartStatus==0?Colors.red: Colors.black,fontWeight: FontWeight.bold,),
      ],
    ),
    );
}

  Padding _topRow(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
          customDateWidget(date: model!.createdAt,fontSize: 14,textColor: Colors.white),
      CustomText(text:"الكمية: "+model!.totalItemCount!.toString(),color: Colors.white,),
      CustomText(text:"اجمالي: \$"+model!.totalPrice!,color: Colors.white,),

      ],),
    );
  }

  Padding _dataRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: (){
          if(_checkEdit(model!.orderCartList!)){
            _showUpdateAddressDialog(context);
          }
        },
        child: CustomText(
          text: "البلد : ${model!.addressModel!.country}  ||  المدينة :  ${model!.addressModel!.city}  ||  الرقم البريدي : ${model!.addressModel!.postCode}  الهاتف 1 : ${model!.addressModel!.phone1}  ||  هاتف اخر :  ${model!.addressModel!.phone2} "
          ,color: Colors.white,alignment: Alignment.centerRight,textAlign: TextAlign.right,),
      ),
    );
  }

  bool _checkEdit(List list){
    bool value=false;
    for (var element in list) {
      value=element["cart_status"]==1?false:true;
      if(value==false){
        break;
      }
    }
    return value;
  }

  void _showUpdateAddressDialog(BuildContext context){
    showDialog(context:context,builder:(BuildContext context)=>
      Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          scrollable: true,
          shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: CustomText(text:"تغيير العنوان",fontSize: 20,fontWeight: FontWeight.bold,),
          content: SizedBox(
            height:300,
            child:ListView.builder(
                itemCount:ecommerceProvider!.addressList.length,
                itemBuilder: (context,position){
                  return _addressCard(position,context);
                }

            ),
          ),
        actions: [  TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
        ],),
      ),

      barrierDismissible: true,
    );
  }

  InkWell _addressCard(int position,BuildContext context) {
    return
    InkWell(onTap: ()async{
      Navigator.pop(context);
       await ecommerceProvider!.orderOperations(
      type: "change address",
      addressId:ecommerceProvider!.addressList[position].id,
      orderId: model!.orderId
      );
    },child: Container(
    padding: const EdgeInsets.all(8.0),
    margin:const EdgeInsets.all(8.0) ,
    decoration: BoxDecoration(color: Colors.grey[100],border: Border.all(color:Colors.blue),borderRadius: BorderRadius.circular(10))
    ,width: double.infinity,child: Column(children: [
      CustomText(text: "البلد : ${ecommerceProvider!.addressList[position].country}  ||  المدينة :  ${ecommerceProvider!.addressList[position].city}  ||  الرقم البريدي : ${ecommerceProvider!.addressList[position].postCode}  ",color: Colors.grey,alignment: Alignment.centerRight,textAlign: TextAlign.right,),
      CustomText(text: "الهاتف 1 : ${ecommerceProvider!.addressList[position].phone1}  ||  هاتف اخر :  ${ecommerceProvider!.addressList[position].phone2} ",color: Colors.grey,alignment: Alignment.centerRight,textAlign: TextAlign.right,),

    ],),),);
  }

  Padding _deleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(color:const[Colors.white,Colors.white],textColor: Colors.blue,text: 'حذف الطلب',
          onPress: ()=>showDialogFor(context:context,title: "حذف",contentText: "هل تريد حذف الطلب بالفعل",onPress: ()async{
            Navigator.pop(context);
            await ecommerceProvider!.orderOperations(
            type: "delete",
            orderId: model!.orderId
            );
          })),
    );
  }


}
