import 'package:all/PL/widgets/custom_textfield.dart';
import 'package:all/Provider/doctor_provider.dart';
import 'package:flutter/material.dart';

int currentIndex = 0;

showOperationDialog({BuildContext? context,String? patientName="",int? docId=0, String? painDesc=""  ,int? bookId=0,String? type,DoctorProvider? doctorProvider}) {

  final _formKey=GlobalKey<FormState>();
  String newPatienName=patientName!;
  String newPainDesc=painDesc!;

  showDialog(context:context!,builder:(context)=>
      SizedBox(height: 300,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            scrollable: true,
            shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text(type=="حذف"?"تنبيه للحذف":type=="تعديل"?"تعديل الحجز":"إضافة حجز"),
            content:
  type=="حذف"
  ?
  const Text("هل تريد الحذف بالفعل",style: TextStyle(fontSize: 14),)
      :
  Form(
  key: _formKey,
  child:
  Column(
  children: [
  CustomTextField(
  initialValue: newPatienName,
  lable:"اسم المريض",
  onSave: (value){
  newPatienName=value;
  },),
  const SizedBox(height: 15),
  CustomTextField(
  initialValue: newPainDesc,
  lable:"وصف الحالة",
  onSave: (value){
  newPainDesc=value;
  },),
  ],
  ),

  ),
            actions: <Widget>[
              TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
              TextButton(
                onPressed: ()async{
                              if(type!="حذف")_formKey.currentState!.save();
                              if(type=="حذف"||_formKey.currentState!.validate()){
                                    Navigator.pop(context);
  await doctorProvider!.bookingOperations(
                                    type: type=="حذف"?"delete":type=="تعديل"?"update":"add",patientName: newPatienName,painDesc: newPainDesc,bookingId: bookId,docId: docId);
                              }},
                child: Text(type!),),
            ],

          ),
        ),
      ),

    barrierDismissible: true,
  );
}
