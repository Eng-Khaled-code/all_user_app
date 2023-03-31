
import 'package:all/Models/courses/course_model.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/courses_provider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/constant.dart';
class CourseCard extends StatefulWidget {
  final CourseModel ? model ;
  final CourseProvider? courseProvider;
  const CourseCard({Key? key, this.model,this.courseProvider})
      : super(key: key);

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isFavLoading=false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10, right: 10, bottom: 5),
            child: Column(
              children: [
                _topRowWidget(),
                const Divider(),
                _middleRowWidget(),
                _discountWidget(),
                const Divider(),
                _bottomRow(),

              ],
            )
        ),
      ),
    );
  }

  Row _middleRowWidget(){
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _courseImage(),
          const SizedBox(width: 5),
          _dataColumn()
        ]
    );
  }

  Container _courseImage() {
    Size _size=MediaQuery.of(context).size;
    return
      Container(
        height: _size.width * .2,
        width: _size.width * .3,
        decoration: BoxDecoration(border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(15),
          image:
          DecorationImage(image: NetworkImage(widget.model!.imageUrl!),
            fit: BoxFit.cover,
            onError: (k, l) =>
                Image.asset(
                  "assets/images/errorimage.png",
                  fit: BoxFit.fill,
                ),),
        ),

      );
  }

  Expanded _dataColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: widget.model!.name!, color: Colors.black, fontWeight: FontWeight.bold,
            maxLine: 1, textAlign: TextAlign.right, alignment: Alignment.topRight,),
          _courseDescription(),
          _dateWidget(),
          _priceRow(),

        ]
      ),
    );
  }

  Row _priceRow(){
    return Row(
        children: [
   _priceContainer(),
    _priceAfterDiscountContainer(),

    ],);
  }

  Container _priceContainer(){
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding:const EdgeInsets.all(5),
      child: Text("${widget.model!.price}\$",style: TextStyle(decoration:widget.model!.discountStatus==1?TextDecoration.lineThrough:TextDecoration.none),),
      decoration: BoxDecoration(
        color:widget.model!.discountStatus==1?Colors.red: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
    );

  }

  Container _priceAfterDiscountContainer(){
    return
      widget.model!.discountStatus==1?_specialColoredContainer(text: "${widget.model!.priceAfterDiscount}\$"):Container();
  }

  Container _specialColoredContainer({String? text}) {
    return Container(
      padding:const EdgeInsets.all(5),
      child: Text(text!,style:const TextStyle(color: Colors.white),),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );

  }

  Text _courseDescription() {
    return Text(widget.model!.desc!, maxLines: 3,
      textAlign: TextAlign.start,
      style: const TextStyle(overflow: TextOverflow.ellipsis),);
  }

  Row _bottomRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _likeWidget(),

    likeWidget(counter: widget.model!.rate.toString(),icon: Icons.star,iconColor: Colors.orange),
    likeWidget(counter: widget.model!.videosCount.toString(),icon: Icons.video_library,iconColor: Colors.orange),
    ],
    );
  }


  InkWell _likeWidget() {
    return InkWell(
        onTap: ()async{

          setState(()=>isFavLoading=true);
          await widget.courseProvider!.favourateOperations(courseId: "${widget.model!.id}",type: widget.model!.isFav==0?"like":"dislike");
          setState(()=>isFavLoading=false);

        },
        child:  isFavLoading? Container(padding:const EdgeInsets.all(10),width: 40,height: 40,child:const CircularProgressIndicator(strokeWidth: .7,),)
            :widget.model!.isBlack==1?Container():Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 40,
    child: Row(
    children: [
    CustomText(
    text:"${widget.model!.likeCount}",
    color: Colors.grey,),
    const SizedBox(width: 10),
    Icon(Icons.favorite,color:widget.model!.isFav==1?Colors.pink:Colors.grey),
    ],
    ),),
    );
  }


  _discountWidget() {
    return Row(
      children: [

    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: Row(
        children: [
          CustomText(
            text: widget.model!.discountStatus == 0 ? "لا يوجد خصم":"${widget.model!.
            descountPercentage}%",
            color: Colors.grey, fontSize: 12,),
          const SizedBox(width: 10),
          const Icon(Icons.money_off, color: Colors.green,),

        ],
      ),),
    widget.model!.discountStatus==1?Text(" ينتهي "+widget.model!.discountEndsIn!.substring(0,10)):Container(),

    ],
    );
  }

   _topRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      _specialColoredContainer(text:widget.model!.category),
      _specialColoredContainer(text:"مقيمين:"+widget.model!.usersCountRattings.toString()),
     _blackListWidget(),
    ],
    );
    }

  Directionality _dateWidget() {
    String date = widget.model
    !.date!;
    return Directionality(
    textDirection: TextDirection.ltr,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
    CustomText(text: "  الساعة =>  "+date.substring(date.length-8,date.length-3),maxLine: 1,color: Colors.black,fontSize: 12,),
    CustomText(text: date.substring(0,date.length-8),maxLine: 1,color: Colors.black,fontSize: 12,),

    ]
    ,
    )
    ,
    );
  }


  Widget _blackListWidget() {
    return widget.model!.isFav==0?IconButton(onPressed: ()=>showDialogFor(
    context:context,
    contentText: widget.model!.isBlack==0?"هل تريد وضع هذا المنتج في القائمة السوداء":"هل تريد إزالة هذا المنتج من القائمة السوداء",
    title: "تأكيد",
    onPress: ()async{
    Navigator.pop(context);
    await widget.courseProvider!.favourateOperations(courseId: "${widget.model!.id}",type: widget.model!.isBlack==0?"black":"unblack");
    }),icon: Icon(widget.model!.isBlack==0?Icons.visibility_off:Icons.visibility)):Container();
    }



}