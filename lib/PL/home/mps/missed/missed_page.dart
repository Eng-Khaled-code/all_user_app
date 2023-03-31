import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/mps_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mps_constant.dart';
import 'missed_card.dart';
class MissedPage extends StatefulWidget {

  MissedPage({Key? key}) : super(key: key);

  @override
  State<MissedPage> createState() => _MissedPageState();
}

class _MissedPageState extends State<MissedPage> {
  String selectedStatus="انتظار";
  List<String> missedStatusList=["انتظار","مقبول","مرفوض"];
  @override
  Widget build(BuildContext context) {
    MPSProvider mpsProvider=Provider.of<MPSProvider>(context);

    return  SafeArea(
        child:  Column(
        children: [
          _missedStatusWidget(),
          _dataWidget(mpsProvider),
          ],),
      );}


  _dataWidget(MPSProvider mpsProvider){
    int itemCount=
    selectedStatus=="انتظار"&&currentIndex==0
        ?
    mpsProvider.waitingMissedList.length
        :
    selectedStatus=="مقبول"&&currentIndex==0
        ?
    mpsProvider.acceptedMissedList.length
        :
    selectedStatus=="مرفوض"&&currentIndex==0
        ?
    mpsProvider.refusedMissedList.length
        :
    selectedStatus=="انتظار"&&currentIndex==1
        ?
    mpsProvider.waitingFoundList.length
        :
    selectedStatus=="مقبول"&&currentIndex==1
        ?
    mpsProvider.acceptedFoundList.length
        :
    selectedStatus=="مرفوض"&&currentIndex==1
        ?
    mpsProvider.refusedFoundList.length
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
          selectedStatus=="انتظار"&&currentIndex==0&&mpsProvider.waitingMissedList.isEmpty ? noDataCard(text: "لا توجد تبليغات عن مفقودين قائمة الانتظار",icon: Icons.library_books)
              :
          selectedStatus=="مقبول"&&currentIndex==0 && mpsProvider.acceptedMissedList.isEmpty ? noDataCard(text: "لا توجد تبليغات عن مفقودين مقبولة",icon: Icons.library_books)
              :
          selectedStatus=="مرفوض"&&currentIndex==0 && mpsProvider.refusedMissedList.isEmpty ? noDataCard(text: "لا توجد تبليغات عن مفقودين  مرفوضه",icon: Icons.library_books)
              :
          selectedStatus=="انتظار"&&currentIndex==1 && mpsProvider.waitingFoundList.isEmpty ? noDataCard(text: "لا توجد تبليغات إيجاد  قائمة الانتظار",icon: Icons.library_books)
              :
          selectedStatus=="مقبول"&&currentIndex==1 && mpsProvider.acceptedFoundList.isEmpty ? noDataCard(text: "لا توجد تبليغات إيجاد مقبولة",icon: Icons.library_books)
              :
          selectedStatus=="مرفوض"&&currentIndex==1 && mpsProvider.refusedFoundList.isEmpty?noDataCard(text: "لا توجد تبليغات إيجاد مرفوضه",icon: Icons.library_books)

              :
          SizedBox(
            child:
            ListView.builder(
                itemCount:itemCount,
                itemBuilder: (context,position){
                  switch(selectedStatus)
                  {
                    case "انتظار" :
                      return  MissedCard(model:currentIndex==0?mpsProvider.waitingMissedList[position]:mpsProvider.waitingFoundList[position],mpsProvider:mpsProvider);
                    case "مقبول":
                      return  MissedCard(model:currentIndex==0?mpsProvider.acceptedMissedList[position]:mpsProvider.acceptedFoundList[position],mpsProvider:mpsProvider);
                    case "مرفوض":
                      return  MissedCard(model:currentIndex==0?mpsProvider.refusedMissedList[position]:mpsProvider.refusedFoundList[position],mpsProvider:mpsProvider);
                    default:
                      return Container();
                  } }

            ),
          ),
        ));
  }


  _missedStatusWidget() {

    return Align(alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          width: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: missedStatusList.length,
              itemBuilder: (context,position){
                return InkWell(
                    onTap: ()=>setState(()=>selectedStatus=missedStatusList[position]),
                    child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: selectedStatus==missedStatusList[position]?primaryColor:Colors.transparent),
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                            text: missedStatusList[position],
                            color:
                            selectedStatus==missedStatusList[position]
                                ?
                            Colors.white
                                :
                            primaryColorDark
                        )
                    ));

              }),
        ),
      ),
    );

  }

}