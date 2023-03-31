import 'package:all/Models/doctor/doctor_model.dart';
import 'package:all/Models/user/rate_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/doctor_provider.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../doctor_constant.dart';
class DoctorCard extends StatelessWidget {
  final DoctorModel? model;
  final DoctorProvider? doctorProvider;

  const DoctorCard({Key? key,this.model,this.doctorProvider}):super(key: key);

  @override
  Widget build(BuildContext context){
    return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: customDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _topRow(context),
            _doctorImageWidget(),
            _nameWidget(),
            _rateWidget(context),
            _specializationWidget(),
            _workDaysWidget(),
            phonesWidget(adminName: model!.name,phones: model!.phones),
            _addBooking(context)
          ],

      ),
    );
  }

  Row _topRow(BuildContext context) {
    return Row(
         crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children:[
          coloredContainer(text: model!.clinickStatus==0?"مغلق":"متاح للحجز"),
          const SizedBox(width: 10),
          _closingReasonWidget()]),
        ],
    );
  }

  Widget  _closingReasonWidget() {
    return    model!.clinickStatus==0? Text(model!.closingReason!):Container();
  }

  CircleAvatar _doctorImageWidget(){
    return   CircleAvatar(backgroundImage: NetworkImage(model!.image==""?appImage:model!.image!),radius: 80);
  }

  CustomText _nameWidget(){
    return CustomText(text: model!.name!,fontWeight: FontWeight.bold,fontSize: 18);
  }

  InkWell _rateWidget(BuildContext context) {
    return InkWell(
      onTap: (){
        RateModel rateModel=RateModel.fromSnapshot(
            {"user1_id":0,
              "user2_id":model!.id,
              "rate":"0",
              "comment":"",
              "email":"",
              "image_url":model!.image,
              "username":model!.name,
              "date":""});
        showRateDialog("تقييم",rateModel,context);
      },
      child: RatingBar.builder(

          initialRating: double.parse(model!.ratings!),
          ignoreGestures:true,
          itemSize: 25,
          direction: Axis.horizontal,allowHalfRating: true
          ,itemCount: 5,onRatingUpdate: (value){},
          itemBuilder: (context,_)=>const Icon(Icons.star,color: Colors.amber,)),
    );
  }

  Padding _specializationWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomText(text: model!.about!+"\n"+"عنوان العيادة : "+model!.address!,textAlign: TextAlign.right,fontWeight: FontWeight.bold,alignment: Alignment.topRight,maxLine: 3,),
    );
  }

  Container _workDaysWidget() {

    return Container(
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        height: 140,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model!.workDays!.length,
            itemBuilder: (context,position){

              return _item(
                  day: model!.workDays![position]["day"],
                  from:   model!.workDays![position]["start_time"],
                  to:   model!.workDays![position]["end_time"]);

            }));
  }

  Material _item({String? day,String? from ,String? to}){

    return  Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 1,
      child: Container(
          padding: const EdgeInsets.all( 8.0),
          margin:const EdgeInsets.all(8.0),
          decoration:BoxDecoration(
              border: Border.all(color: primaryColor),
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            CustomText(text:day! ,fontWeight: FontWeight.bold,fontSize: 16,),
          CustomText(text:"من "+from!.substring(0,5)+"\n إلي "+to!.substring(0,5) ,color: Colors.grey,fontSize: 14,), ],
    ),),
    );
  }

  Widget _addBooking(BuildContext context) {
    return model!.clinickStatus==1?Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(color:const[Colors.blue,Colors.blue],textColor: Colors.white,text: 'إحجز الان',onPress: ()=>
        showOperationDialog(
    doctorProvider: doctorProvider,
            context: context,
            docId: model!.id,
            bookId: 0,
            type: "إضافة",
            patientName: "",
            painDesc: ""
        )),
    ):Container();
  }
}
