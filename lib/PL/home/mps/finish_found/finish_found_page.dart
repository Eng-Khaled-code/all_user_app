import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/mps_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mps_constant.dart';
import 'finish_card.dart';
class FinishFoundPage extends StatelessWidget {

    // ignore: prefer_const_constructors_in_immutables
  const  FinishFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MPSProvider mpsProvider=Provider.of<MPSProvider>(context);

    return  SafeArea(
        child:  Column(children: [
          _dataWidget(mpsProvider),
          ],),
      );}


  _dataWidget(MPSProvider mpsProvider){
    int itemCount=
    currentIndex==2
        ?
    mpsProvider.foundList.length
        :
    currentIndex==3
        ?
    mpsProvider.helpToFoundList.length
        : 0;

    return Expanded(
        child: RefreshIndicator(
          onRefresh: ()async{
            await mpsProvider.loadMPSData("out");
          },
          child: mpsProvider.isLoading
              ?
          loadingMpsWidget()
              :
          currentIndex==2&&mpsProvider.foundList.isEmpty ? noDataCard(text: "لا توجد طلبات",icon: Icons.library_books)
              :
          currentIndex==3 && mpsProvider.helpToFoundList.isEmpty ? noDataCard(text: "لا توجد طلبات",icon: Icons.library_books)
              :
          SizedBox(
            child:
            ListView.builder(
                itemCount:itemCount,
                itemBuilder: (context,position){
                  switch(currentIndex)
                  {
                    case 2 :
                      return  FinishFoundCard(model:mpsProvider.foundList[position],cardType: "found",);
                    case 3:
                      return  FinishFoundCard(model:mpsProvider.helpToFoundList[position],cardType: "helpToFind",);
                    default:
                      return Container();
                  } }

            ),
          ),
        ));
  }



}