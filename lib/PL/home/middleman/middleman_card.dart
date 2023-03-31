import 'package:all/Models/middleman/middleman_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/middleman_provider.dart';
import 'package:flutter/material.dart';
class MiddlemanCard extends StatelessWidget {
  final MiddlemanModel? model;
  final MiddlemanProvider? middlemanProvider;
   MiddlemanCard({Key? key,this.model,this.middlemanProvider}):super(key: key);
  String _typeInArabic="";

  @override
  Widget build(BuildContext context){

    _typeInArabic=model!.type=="block"?"عمارة ":model!.type=="flat"?"شقة ":model!.type=="local_store"?"محل ":model!.type=="ground"?"قطعة أرض ":"";
    return  Container(
          margin:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             _topRow(context),
             _dataWidget(),
             _bottomRow(context)

          ],

      ),
    );
  }

  Widget _topRow(BuildContext context){
    return
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminProfileWidget(
            context: context,
            name: model!.adminName,
            image: model!.adminImage,
            adminId:model!.adminId,
            ratings: model!.ratings,
            date: model!.date,
            opertionType: model!.operation!+" "+_typeInArabic
        ),
        _actionsRow(context),],);
  }

  Widget _dataWidget(){
   String roufNum=model!.type=="flat"?"رقم الطابق : ":model!.type=="block"?"عدد الطوابق":"";
 return
     Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
             children: [
         CustomText(text: "الإجمالي \$  ${double.tryParse(model!.totalPrice!)!.toStringAsFixed(3)}",fontSize: 26,fontWeight: FontWeight.bold,),
    const SizedBox(height: 10),
 CustomText(text:"$_typeInArabic  المساحة  ${model!.size}  متر  ||  سعر المتر   ${model!.metrePrice}  ||  "+(model!.type=="flat"||model!.type=="block"?"$roufNum  ${model!.roufNum}":""),color: Colors.grey,alignment: Alignment.centerRight,textAlign:TextAlign.right),
    const SizedBox(height: 10),
    CustomText(
 text:"العنوان :  ${model!.address}",
 color: Colors.grey,maxLine: 2,alignment: Alignment.centerRight,textAlign:TextAlign.right),
 const SizedBox(height: 10),
 CustomText(text: "تفاصيل اكثر : ${model!.moreDetails}",color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
    const SizedBox(height: 10),
    CustomText(text: "للتواصل اتصل عبر :",color: Colors.grey,alignment: Alignment.centerRight,maxLine: 3,textAlign: TextAlign.right,),
    phonesWidget(adminName: model!.adminName,phones: model!.adminPhones)

   ],
   ),
   );
 }

  Widget _bottomRow(BuildContext context) {
    return       Column(
      children: [
        const Divider(color: Colors.grey,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                      model!.isPurechased==1?Container():_discussWidget(),
                      _likeWidget()
          ],
        ),
      ],
    );
  }

  Widget _discussWidget(){
    return
      middlemanProvider!.isDiscussLoading? Container(padding:const EdgeInsets.all(10),width: 40,height: 40,child:const CircularProgressIndicator(strokeWidth: .7,),)
        :model!.isBlack==1?Container():
    TextButton(child: Row(
    children: [
    Icon(model!.isDiscuss==1?Icons.loop:Icons.add_to_photos,color:model!.isDiscuss==1?Colors.blue:Colors.grey),
    CustomText(text:model!.isDiscuss==1?"  جار المفاوضة": "  تفاوض",color:model!.isDiscuss==1?Colors.blue:Colors.grey)
    ],
    ),onPressed: ()async{
    await middlemanProvider!.discussOperation(postId: model!.placeId.toString(),type:model!.isDiscuss==1?"dis_discuss":"discuss" );
    },);
  }

  Widget _likeWidget() {
    return
      middlemanProvider!.isFavLoading? Container(padding:const EdgeInsets.all(10),width: 40,height: 40,child:const CircularProgressIndicator(strokeWidth: .7,),)
        :model!.isBlack==1?Container():
    TextButton(child: Row(
    children: [
    Icon(Icons.favorite,color:model!.isFav==1?Colors.pink:Colors.grey),
    CustomText(text:"${model!.likeCount}  ".toString(),color:model!.isDiscuss==1?Colors.pink:Colors.grey)
    ],
    ),onPressed: ()async{
    await middlemanProvider!.favourateOperations(postId: model!.placeId.toString(),type:model!.isFav==1?"dislike":"like" );
    },);
  }

  Row _actionsRow(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: (){},icon:const Icon(Icons.notifications_active,color: Colors.blue,),),
        _blackListWidget(context)

      ],
    );
  }

  Widget _blackListWidget(BuildContext context) {
    return model!.isFav==0?IconButton(onPressed: ()=>showDialogFor(
    context:context,
    contentText: model!.isBlack==0?"هل تريد الوضع في القائمة السوداء":"هل تريد الإزالة من القائمة السوداء",
    title: "تأكيد",
    onPress: ()async{
    Navigator.pop(context);
    await middlemanProvider!.favourateOperations(postId: "${model!.placeId}",type: model!.isBlack==0?"black":"unblack");
    }),icon: Icon(model!.isBlack==0?Icons.visibility_off:Icons.visibility)):Container();
    }


}
