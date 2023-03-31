import 'package:all/Models/doctor/booking_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import '../doctor_constant.dart';

class BookingCard extends StatelessWidget {
  final BookingModel? model;
  DoctorProvider? doctorProvider;
   BookingCard({Key? key,this.model,this.doctorProvider}):super(key: key);

  @override
  Widget build(BuildContext context) {
  return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: customDecoration(),
      child: Column(
      children: [
        _topRow(context),
        _columnData(context),
        _bottomRow()
      ],
    )

    );
  }

  Row _bottomRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        coloredContainer(text: model!.bookType),
        _clinicStatus(),
        _numInQueueWidget(),
      ],
    );
  }

  Padding _columnData(BuildContext context){

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center
    ,children: [
      CustomText(text:model!.patientName!,color: primaryColor,fontSize: 18,fontWeight: FontWeight.bold,alignment: Alignment.center,),
      CustomText(text:model!.painDesc!,color: primaryColor,alignment: Alignment.center,),
    model!.notes!=""? CustomText(text:model!.notes!,color: primaryColor,alignment: Alignment.center,):Container(),
    model!.bookStatus! =="ACCEPTED"?  CustomText(text:"تاريخ القدوم: "+model!.finalBookDate!,color: primaryColor,):Container(),
      const SizedBox(height: 20),
      ]),
  );

  }

  Row _topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        adminProfileWidget(image:model!.docImage,name:model!.docName,date:model!.reqDate),
        _operationRow(context)
      ],
    );
  }

  Widget _numInQueueWidget() {

    return model!.bookStatus=="ACCEPTED"? Align(
        alignment: Alignment.bottomLeft,
        child: coloredContainer(text:"رقم الدور : "+model!.numInQueue!.toString()),
    ):Container();
  }

  Widget _operationRow(BuildContext context) {

    return model!.bookStatus!="ACCEPTED"?Row(
      children: [
        _updateWidget(context),
        _deleteWidget(context)
      ],
    ):Container();
  }

  IconButton _updateWidget(BuildContext context) {
    return IconButton(onPressed:()=>showOperationDialog(
      doctorProvider: doctorProvider,
        context: context,
        docId: model!.docId,
        bookId: model!.id,type: "تعديل",
        patientName: model!.patientName,
        painDesc: model!.painDesc
    ),icon: const Icon(Icons.edit,color: primaryColor),);
  }

  IconButton _deleteWidget(BuildContext context) {
    return IconButton(onPressed:()=>showOperationDialog(
      doctorProvider: doctorProvider,
        context: context,
        docId: model!.docId,
        bookId: model!.id,type: "حذف",
        patientName: model!.patientName,
        painDesc: model!.painDesc
    )
      ,icon: const Icon(Icons.delete,color: primaryColor),);
  }

  Widget _clinicStatus() {
    return model!.clinickStatus==0?CustomText(text: model!.closingReason!,):Container();
  }


}
