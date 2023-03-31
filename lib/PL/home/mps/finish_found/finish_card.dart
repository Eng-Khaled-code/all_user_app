import 'package:all/Models/mps/found_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:flutter/material.dart';
class FinishFoundCard extends StatelessWidget {
  final FoundModel? model;
  final String? cardType;

 const FinishFoundCard({Key? key,this.model,this.cardType}):super(key: key);

  @override
  Widget build(BuildContext context){

    return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              adminProfileWidget(name: cardType=="found"?model!.fUsername:model!.username,image: cardType=="found"?model!.fUserImage:model!.userImage,date: model!.date),
             phonesWidget(phones: cardType=="found"?model!.fUserPhones:model!.userPhones,adminName:cardType=="found"?model!.fUsername:model!.username ),
              _dataWidget(image:model!.missedImage,name: model!.name,lastPlace: model!.lastPlace),
              const Divider(),
              _dataWidget(image:model!.fMissedImage,lastPlace: model!.fLastPlace),

            ],

      ),
    );
  }



  _dataWidget({String? image,String?name="",String?lastPlace}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          imageWidget(image:image!,height: 200),
          name==""?Container():CustomText(text:name!,fontSize: 20,fontWeight: FontWeight.bold,),
          CustomText(text: "اخر مكان وجد به : ${lastPlace}",color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
        ],
      ),
    );
  }




}
