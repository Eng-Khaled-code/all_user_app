import 'package:all/Models/mps/missed_model.dart';
import 'package:all/PL/home/mps/add_missed/add_missed.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_alert_dialog.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/mps_provider.dart';
import 'package:flutter/material.dart';
class MissedCard extends StatelessWidget {
  final MissedModel? model;
  final MPSProvider? mpsProvider;

  MissedCard({Key? key,this.model,this.mpsProvider}):super(key: key);

  @override
  Widget build(BuildContext context){
    return  Container(
      margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            _topRow(context),
            imageWidget(image:model!.image!),
              _dataWidget(),
        model!.missedOrFound=="فقد"&&model!.missedStatus=="مقبول"? _suggestionsWidget():Container()
          ],

      ),
    );
  }

  _topRow(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dateWidget(),
          _operationRow(context)

    ],
    );
  }

  _dateWidget() {
    return     Directionality(textDirection:TextDirection.ltr,child: Text(model!.createdAt!.toString().substring(0,model!.createdAt!.length-3)));
  }



  _dataWidget(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomText(text:model!.name!,fontSize: 20,fontWeight: FontWeight.bold,),
          CustomText(text: "النوع : ${model!.sex}   ||  العمر:  ${model!.age}   ||   لون العين : ${model!.eyeColor}   ||   لون البشرة :${model!.faceColor}   ||    لون الشعر:  ${model!.hairColor}",color: Colors.grey,alignment: Alignment.centerRight,textAlign: TextAlign.right,),
          CustomText(text: "اخر مكان وجد به : ${model!.lastPlace}",color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
          CustomText(text:  model!.missedOrFound=="فقد"&&model!.missedStatus=="مقبول"?"الاقتراحات":model!.missedStatus=="مرفوض"?("سبب الرفض : "+model!.refuseReason!):"",color: Colors.grey,alignment: Alignment.centerRight,),
        ],
      ),
    );
  }


  _operationRow(BuildContext context) {

    return Row(
    children: [
    model!.missedStatus!="مقبول"?_updateWidget(context):Container(),
    _deleteWidget(context)
    ],
    );
    }

  _updateWidget(BuildContext context) {
    return IconButton(onPressed:(){
      goTo(context: context, to:AddMissed(
        addOrUpdate: "تعديل",
        messedOrFound:model!.missedOrFound,
        id: model!.id,
        imageUrl: model!.image,
        hairColor: model!.hairColor,
        faceColor: model!.faceColor,
        eyeColor: model!.eyeColor,
        missedStatus: model!.missedStatus,
        name: model!.name,
        sex: model!.sex,
        helthyStatus: model!.helthyStatus,
        lastPlace: model!.lastPlace,
        age: model!.age,

      ));
    },icon: const Icon(Icons.edit,color: primaryColor),);
  }

  _deleteWidget(BuildContext context) {
    return IconButton(onPressed:()=>showDialogFor(context:context,contentText: "هل تريد الحذف بالفعل",title: "حذف",onPress: ()async{
      Navigator.pop(context);
      await mpsProvider!.missedOperations(id: model!.id,imageUrl: model!.image,addOrUpdateOrDelete: "delete",missedOrFound: model!.missedOrFound,missedStatus: model!.missedStatus);

    })
      ,icon: const Icon(Icons.delete,color: primaryColor),);
  }

  _suggestionsWidget() {
    return
    model!.missedOrFound=="فقد"&&model!.suggestions!.isEmpty?

    Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomText(text: "لا توجد إقتراحات",color: Colors.grey,alignment: Alignment.centerRight,),
    )
        :model!.missedOrFound=="فقد"&&model!.suggestions!.isNotEmpty
    ?

    SizedBox(
    height: 250,
    child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: model!.suggestions!.length,
    itemBuilder: (context,position){
    return GestureDetector(
    onTap: (){
      if(model!.suggestions![position]['suggest_status']=="not identical"){
        _showSuggestionTrueDialog(context: context,foundId: model!.suggestions![position]['fount_id']);
    }

    },
    child: Container(
    padding:const EdgeInsets.all(5) ,
    margin:const EdgeInsets.all( 5)  ,
    width:250,
    decoration:  BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10)),
    child: Column(children: [
    _suggTopRow(position),
    const SizedBox(height: 10),
    imageWidget(image:model!.suggestions![position]['f_missed_image'],height: 170),

    ],),
    ),
    );}),
    ):Container()
    ;

  }



  _showSuggestionTrueDialog({
    BuildContext? context,int? foundId
  }) {
    showDialog(
        context: context!,
        builder: (context) => CustomAlertDialog(
            title: "تنبيه",
            text: "هل انت متاكد من ان هذا الشخص هو الذي تبحث عنه",
            onPress: () async {
              Navigator.pop(context);
                   await mpsProvider!.suggetionTrue(messedId: model!.id,foundId: foundId);
                }
                ));
  }

  _suggTopRow(int position) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
    adminProfileWidget(name: model!.suggestions![position]['f_username'],image: model!.suggestions![position]['f_user_image'],date: model!.suggestions![position]['date']),
    model!.suggestions![position]['suggest_status']=="identical"?const Icon(Icons.check,color: Colors.white):Container()
    ],
    );
  }
}
