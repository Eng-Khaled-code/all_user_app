
import 'package:all/PL/widgets/custom_textfield.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:flutter/material.dart';

myCustomDialog({String? addOrUpdateOrDelete,String? type,String? fieldValue,String? fieldId,BuildContext? context,UserProvider? userProvider}){
  final _formKey=GlobalKey<FormState>();
  String title=
  type=="phone"&&addOrUpdateOrDelete=="add"
      ?
  "إضافة رقم تليفون جديد"
      :
  type=="phone"&&addOrUpdateOrDelete=="update"
      ?
  "تعديل رقم التليفون"
      :
  type=="phone"&&addOrUpdateOrDelete=="delete"
      ?
  "حذف رقم التليفون"
      :
  type=="username"
      ?
  "الاسم"
      :
  "العنوان";
  String deleteText=type=="phone"?"هل تريد حذف  $fieldValue":"";
  String finalValue="";


  showDialog(context: context!,
    builder: (context)
    => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title:Text(title),
              content: Form(
                key: _formKey,
                child: addOrUpdateOrDelete=="delete"
                  ?
              Text(deleteText)
                  :
               CustomTextField(
                  initialValue: fieldValue,
                  lable:type=="phone"? "رقم التليفون":type=="username"
                      ?
                  "الاسم"
                      :
                  "العنوان",
                  onSave: (value){
                    finalValue=value;
                  },),
              ),

              actions: <Widget>[
                TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
               TextButton(onPressed: (){

                 _formKey.currentState!.save();

                   if((addOrUpdateOrDelete=="delete")||_formKey.currentState!.validate()){

                   if (type == "phone") {
                     userProvider!.phoneOperations(
                         type: addOrUpdateOrDelete,
                         phoneId: fieldId,
                         number: finalValue,
                         from:"in"
                     );
                   }
                   else
                     {
                     userProvider!.updateUserFields(key:type,value:finalValue);
                     }
                 Navigator.pop(context);
                 }
               }, child: const Text("موافق"),),
              ],
            ),
          ),
      barrierDismissible: true,
    );

}
