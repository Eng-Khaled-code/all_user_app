import 'package:all/Models/user/rate_model.dart';
import 'package:all/PL/auth/rate_page/rate_card.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider=Provider.of<UserProvider>(context);
    return Directionality(
    textDirection: TextDirection.rtl,
      child:Scaffold(
        backgroundColor: userProvider.userComments.isEmpty?Colors.white:Colors.grey[300],
      appBar: AppBar(
        backgroundColor: userProvider.userComments.isEmpty?Colors.white:Colors.grey[300],
        title: CustomText(text:
        "التقييمات",
          alignment: Alignment.centerRight,
          fontSize: 20,
        ),
        leading:
        Container(margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),
            child: IconButton(icon:const Icon(Icons.arrow_back,color: primaryColor,size: 20,)
                ,onPressed:  ()=>Navigator.pop(context))) ,

      ),
            body:RefreshIndicator(
              onRefresh: ()async{
            await userProvider.getComments("in");
            },
              child :
                 userProvider.isCommentLoading
      ?
      const Center(child: CircularProgressIndicator(),):userProvider.userComments.isEmpty
      ?
      noDataCard("لا توجد تقييمات")
               :

          ListView.builder(itemCount:userProvider.userComments.length,itemBuilder: (context,position){
            RateModel rateModel=RateModel.fromSnapshot(
                userProvider.userComments[position]
            );
             return InkWell(
               onTap: ()=>showRateDialog("تعديل التقييم",rateModel,context),
               child: RateCard(model: rateModel),
             );

                 }),
            ),
            )
    );
  }

  noDataCard(String message){
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
        child:  Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.emoji_emotions,size: 50,color: primaryColor),
          const SizedBox(height: 15.0),
          CustomText(text: message)]
          ,),
      ),
    );
  }



}
