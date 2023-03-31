
import 'package:all/Models/user/rate_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class RateCard extends StatelessWidget {
  final RateModel? model;
  RateCard({this.model});

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(DateTime.parse(model!.date!));
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child:Material(
    elevation: 2,
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),

    child: Column(
     mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
          CircleAvatar(backgroundImage:NetworkImage(model!.commentedUserImage!)),
             Padding(
               padding: const EdgeInsets.only(bottom: 20.0,right: 8.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   CustomText(text:model!.name!+" ",color: primaryColor,fontWeight: FontWeight.bold,fontSize: 16),
         CustomText(text:model!.email!,fontSize: 12,alignment: Alignment.centerRight,color: Colors.grey,),
         CustomText(text: timeago.format(DateTime.now().subtract(difference), locale: 'ar'),fontSize: 12,alignment: Alignment.centerRight,color: Colors.grey,),

                 ],
               ),
             )
            ],
          ),IconButton(onPressed: ()=>showRateDialog("حذف التقييم",model!,context), icon: const Icon(Icons.delete))
      ],
    ),
  ),               Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(model!.comment!,style:const TextStyle(color: Colors.grey)),
  ),

  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text("التقييم : "),
        const Text("5/"),

        Text(model!.rate.toString(),style: const TextStyle(color: primaryColor,fontSize: 30,fontWeight: FontWeight.bold),),
  const SizedBox(width: 15,),
  RatingBar.builder(initialRating: double.parse(model!.rate!.toString()),
            ignoreGestures: true,
            itemSize: 25,
            direction: Axis.horizontal,allowHalfRating: true
            ,itemCount: 5,itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context,_)=>const Icon(Icons.star,color: Colors.amber,),onRatingUpdate: (rating){},)
        ],
      ),
    ),
      ],
    )
    )
    );
  }



}
