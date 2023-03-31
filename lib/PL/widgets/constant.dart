import 'package:all/Models/user/rate_model.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_text.dart';
import 'custom_textfield.dart';

const Color primaryColor=Colors.blue;
const Color primaryColorDark=Colors.black45;
const Color primaryBackgroundColorDark=Colors.black45;

///methods

 void goTo({@required BuildContext? context, @required Widget? to}) {
  Navigator.push(context!, MaterialPageRoute(builder: (context) => to!));
}

  String errorTranslation(String englishErrr) {

  if(englishErrr=="sorry thier was a problem"){
    return "نعتذر يوجد خطأ ما من فضلك اعد فتح التطبيق";
  }
  else if(englishErrr=="your account locked by admin"){
    return "هذا الحساب مغلق يرجي التواصل مع مالك التطبيق";
  }
  else if(englishErrr=="email not correct"){
    return "الإيميل غير صحيح";
  }
  else if(englishErrr=="email or password not valid"){
    return "الايميل او كلمة المرور غير صحيحة";
  }
  else if(englishErrr=="failed to open database"){
    return "نعتذر يوجد خطأ يرجي إبلاغ مالك التطبيق";
  }

  else if(englishErrr=="error while addition"){
    return "لم تتم الإضافة";
  }
  else if(englishErrr=="error while update"){
    return "لم يتم التعديل";
  }
  else if(englishErrr=="error"){
    return "تاكد من اتصال الانترنت لديك";
  }
  else if(englishErrr.contains("Duplicate entry")){
    return "انت قمت بتقييم هذا الشخص من قبل";
  }
  else if(englishErrr.contains("Cannot delete or update a parent row")){
    return "لا يمكنك حذف هذا العنوان لانه مرتبط بطلب من قبل";
  }
  else {
    return englishErrr;
  }}

 void showRateDialog(String type,RateModel model,BuildContext context) {

   final _formKey=GlobalKey<FormState>();
    String newComment=model.comment!;
  String newRate=model.rate!;

   showDialog(context: context,
  builder: (context){
  UserProvider userProvider=Provider.of<UserProvider>(context);
  return  Directionality(
  textDirection: TextDirection.rtl,
  child: AlertDialog(
  shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
  title:Text(type),
  content: Form(
  key: _formKey,
  child:
  Column(
  children: [
  CircleAvatar(backgroundImage: NetworkImage(model.commentedUserImage!),radius: 50,),
  CustomText(text: model.name!,color: Colors.black,),
  const SizedBox(height: 20),

  RatingBar.builder(
  initialRating: double.parse(model.rate!),
  ignoreGestures: type=="حذف التقييم"?true:false,
  itemSize: 25,
  direction: Axis.horizontal,allowHalfRating: true
  ,itemCount: 5,itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
  itemBuilder: (context,_)=>const Icon(Icons.star,color: Colors.amber,),onRatingUpdate: (rating){
  newRate=rating.toString();
  },),
  const SizedBox(height: 20),
  CustomTextField(
  initialValue: model.comment,
  lable:type=="حذف التقييم"?"التعليق":"تعليق",
  onSave: (value){
  newComment=value;
  },),
  ],
  ),
  ),

  actions: <Widget>[
  TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
    TextButton(onPressed: ()async{

   _formKey.currentState!.save();

   if(_formKey.currentState!.validate())
  {
    Navigator.pop(context);

  await userProvider.commentOperations(newMessage: newComment,newRate: newRate,otherUserId: model.user2Id.toString(),type: type=="حذف التقييم"?"delete":type=="تعديل التقييم"?"update":"add");
  }
  }
    , child:  Text(type),),
    ],
    scrollable: true,
    ),
    );},
    barrierDismissible: true,

    );


  }

Container  phonesWidget({List? phones,adminName=""}) {

  return Container(
    margin: const EdgeInsets.all(8.0),
    height: 30,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: phones!.length,
      itemBuilder: (context,position)=>InkWell(
        onTap: (){
          showDialog(context: context,builder:(context)=>
            Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(

                shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: Text(adminName),
                content:Text("${phones[position]}",style:const TextStyle(fontSize: 14),),
                actions: <Widget>[
                  TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
                  TextButton(onPressed:()async=> await launch("tel://"+phones[position]),
                    child: const Text("إتصال"),),
                ],


              ),

            ) ,
          barrierDismissible: true,
        );},
        child: Container(
          margin:  const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 30,
          decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.white)),
          child: CustomText(
            text:phones[position],
            color: Colors.white,),),
      ),),
  );
}

SingleChildScrollView noDataCard({String? text,IconData? icon}) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: Container(
      margin: const EdgeInsets.all(8),
      width:double.infinity ,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Icon(icon, size: 60),
          const SizedBox(height: 15),
          CustomText(text:text!,color: Colors.black45,fontSize: 14,fontWeight: FontWeight.bold,),
          const SizedBox(height: 50),
        ],
      ),
    ),
  );}

Container coloredContainer({String? text,Color color=primaryColor}) {
  return
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: color),
      child: CustomText(text:text!,color: Colors.white,),);
}

BoxDecoration customDecoration({Color color=Colors.white,bool? border=true}){
   return BoxDecoration(color:color,borderRadius: BorderRadius.circular(10),border: border!?Border.all(color: Colors.grey):null,);
}

Row adminProfileWidget({BuildContext? context,String? name="",String? image="",String? date,int? adminId=0,Color? color=Colors.black ,String? opertionType="",String? ratings=""}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(width: 5,),
  CircleAvatar(backgroundImage: NetworkImage(image==""?appImage:image!),backgroundColor: Colors.grey,),
  const SizedBox(width: 15,),
  InkWell(
    onTap: (){
      if (adminId !=0 ){
        RateModel rateModel=RateModel.fromSnapshot(
            {"user1_id":0,
              "user2_id":adminId,
              "rate":"0",
              "comment":"",
              "email":"",
              "image_url":image==""?appImage:image!,
              "username":name!,
              "date":""});
        showRateDialog("تقييم",rateModel,context!);
      }

    },
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
    CustomText(text: name!,color: color!,alignment: Alignment.centerRight,fontWeight: FontWeight.bold,maxLine: 1,),
    ratings==""?Container():
    RatingBar.builder(
    initialRating: double.parse(ratings!),
    ignoreGestures:true,
    itemSize: 15,
    direction: Axis.horizontal,allowHalfRating: true
    ,itemCount: 5,onRatingUpdate: (value){},
    itemBuilder: (context,_)=>const Icon(Icons.star,color: Colors.amber,)),
    date==""?Container():customDateWidget(date: date),

    opertionType==""?Container():Container(padding:const EdgeInsets.symmetric(horizontal: 5.0,vertical: 2.0),child: CustomText(text: opertionType!,color: Colors.white,alignment: Alignment.centerRight,fontSize: 12,) ,decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8.0)),)

    ],
    ),
  ),],);
}

customDateWidget({String? date,Color? textColor =Colors.black,double? fontSize=12}) {
   return Directionality(textDirection:TextDirection.ltr,child: Row(
       children: [
   CustomText(text: "  الساعة =>  "+date!.substring(date.length-8,date.length-3),color: textColor!,alignment: Alignment.centerRight,fontSize: fontSize!,maxLine: 1,),
  CustomText(text: date.substring(0,date.length-8),color: textColor,alignment: Alignment.centerRight,fontSize: fontSize,maxLine: 1,),

  ],
  ));
}

Container imageWidget({String? image ,double? height=250 ,double? width=double.infinity}) {
  return Container(
    margin:const EdgeInsets.only(left: 5.0,right: 5.0),
    height: height,
    width: width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:  FadeInImage.assetNetwork(
        placeholder: "assets/images/loading.gif",
        image:
        image!,
        fit: BoxFit.fill,
        imageErrorBuilder:(e,r,t)=> Image.asset(
          "assets/images/errorimage.png",
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}

void showDialogFor({BuildContext? context,Function()? onPress,String? contentText,String? title}) {
  showDialog(context:context!,builder:(context)=>
      SizedBox(height: 300,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            scrollable: true,
            shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text("تنبيه "+title!),
            content: Text(contentText!,style:const TextStyle(fontSize: 14),)
            , actions: <Widget>[
            TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
            TextButton(
              onPressed: onPress,
              child: Text(title),),
          ],

          ),
        ),
      ),

    barrierDismissible: true,
  );
}

AppBar  customAppbar({BuildContext? context,String? title}) {
  return AppBar(
    backgroundColor: Colors.white,

    title: CustomText(text:
    title!,
      alignment: Alignment.centerRight,
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    leading:
    Container(margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),
        child: IconButton(icon:const Icon(Icons.arrow_back,color: primaryColor,size: 20,)
            ,onPressed:  ()=>Navigator.pop(context!))) ,

  );
}



Container likeWidget({String? counter,IconData? icon ,Color? iconColor}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 40,
    child: Row(
      children: [
        CustomText(
          text:counter!,
          color: Colors.grey,),
        const SizedBox(width: 10),
        Icon(icon,color:iconColor),
      ],
    ),);
}