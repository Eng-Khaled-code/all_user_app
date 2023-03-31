import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/middleman_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'middleman_card.dart';
class Middleman extends StatefulWidget {
  const Middleman({Key? key}) : super(key: key);

  @override
  State<Middleman> createState() => _MiddlemanState();
}

class _MiddlemanState extends State<Middleman> {

  TextEditingController searchController = TextEditingController();
  String selectedCategory = "شقة";

  @override
  Widget build(BuildContext context) {

    MiddlemanProvider middlemanProvider=Provider.of<MiddlemanProvider>(context);
    double screenHeight=MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            _buildSearchTextfieldWidget(middlemanProvider),
            _typeWidgets(),
            dataWidget(middlemanProvider,screenHeight),
          ],),
        ),
      ),
    );
  }

  Widget dataWidget(MiddlemanProvider middlemanProvider,double screenHight) {

    int itemCount=
    selectedCategory=="شقة"
        ?
    middlemanProvider.flatList.length
        :
    selectedCategory=="محل"
        ?
    middlemanProvider.storeList.length
        :
    selectedCategory=="عمارة"
        ?
    middlemanProvider.blockList.length
        :
    selectedCategory=="قطعة ارض"
        ?
    middlemanProvider.groundList.length
       :
   selectedCategory=="المفضلة"
       ?
   middlemanProvider.favList.length
       :
   selectedCategory=="تفاوض"
       ?
   middlemanProvider.discusList.length
       :
   selectedCategory=="مشترياتي"
       ?
   middlemanProvider.myPurchasesList.length
       :
   selectedCategory=="القائمة السوداء"
       ?
   middlemanProvider.blackList.length:
    0;


    return Expanded(child: RefreshIndicator(
        onRefresh: ()async{
      await middlemanProvider.loadMiddlemanList("out");

    },
    child: middlemanProvider.isLoading
        ?
    Container(margin:const EdgeInsets.all(20),height:20,width:20,child:const CircularProgressIndicator(strokeWidth: 2,))

        :
    middlemanProvider.flatList.isEmpty&&selectedCategory=="شقة"?noDataCard(text:"لا توجد شقق حاليا" ,icon:Icons.account_balance):
    middlemanProvider.blockList.isEmpty&&selectedCategory=="عمارة"?noDataCard(text:"لا توجد عماير حاليا" ,icon:Icons.account_balance):
    middlemanProvider.storeList.isEmpty&&selectedCategory=="محل"?noDataCard(text:"لا توجد محلات حاليا" ,icon:Icons.account_balance):
    middlemanProvider.groundList.isEmpty&&selectedCategory=="قطعة ارض"?noDataCard(text:"لا توجد قطع ارض حاليا" ,icon:Icons.account_balance):
    middlemanProvider.favList.isEmpty&&selectedCategory=="المفضلة"?noDataCard(text:"القائمة المفضلة فارغة" ,icon:Icons.account_balance):
    middlemanProvider.discusList.isEmpty&&selectedCategory=="تفاوض"?noDataCard(text:"قائمة المفاوضات فارغة" ,icon:Icons.account_balance):
    middlemanProvider.myPurchasesList.isEmpty&&selectedCategory=="مشترياتي"?noDataCard(text:"انت لم تشتري شئ حتي الان" ,icon:Icons.account_balance):
    middlemanProvider.blackList.isEmpty&&selectedCategory=="القائمة السوداء"?noDataCard(text:"القائمة السوداء فارغة" ,icon:Icons.account_balance):

    Container(
      padding:const EdgeInsets.all(5.0),
      child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context,position){
            switch(selectedCategory)
            {
              case "شقة":
                return  MiddlemanCard(model:middlemanProvider.flatList[position],middlemanProvider:middlemanProvider);
              case "عمارة":
                return  MiddlemanCard(model:middlemanProvider.blockList[position],middlemanProvider:middlemanProvider);
              case "محل":
                return  MiddlemanCard(model:middlemanProvider.storeList[position],middlemanProvider:middlemanProvider);
              case "قطعة ارض":
                return MiddlemanCard(model:middlemanProvider.groundList[position],middlemanProvider:middlemanProvider);
              case "المفضلة":
                return MiddlemanCard(model:middlemanProvider.favList[position],middlemanProvider:middlemanProvider);
              case "تفاوض":
                return MiddlemanCard(model:middlemanProvider.discusList[position],middlemanProvider:middlemanProvider);
              case "مشترياتي":
                return MiddlemanCard(model:middlemanProvider.myPurchasesList[position],middlemanProvider:middlemanProvider);
              case "القائمة السوداء":
                return MiddlemanCard(model:middlemanProvider.blackList[position],middlemanProvider:middlemanProvider);
              default:
                return Container();
            }
          }

      )))
    );

  }

  Widget _buildSearchTextfieldWidget(MiddlemanProvider middlemanProvider) {
    return Container(
      margin:const EdgeInsets.all( 10),
      decoration: BoxDecoration(
          border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        onChanged: (value) {
         middlemanProvider.search(searchValue: value);
        },
        style:const TextStyle(color: Colors.grey, fontSize: 14),
        controller: searchController,
        decoration:const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: " بحث بالعنوان ...",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            )),
      ),
    );
  }

  List<String> types=["شقة","محل","عمارة","قطعة ارض","تفاوض","مشترياتي","المفضلة","القائمة السوداء"];

  Widget _typeItem({String? text})=>InkWell(
          onTap: ()=> setState(()=> selectedCategory=text!)
          ,
          child: Container(padding:const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: text==selectedCategory?primaryColor:Colors.transparent),
              child: CustomText(text:text! ,color: text==selectedCategory?Colors.white:Colors.black,alignment: Alignment.topCenter,)
          ));


  Widget _typeWidgets()=>Container(
     margin: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
      height: 41,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        itemBuilder: (context,position)=>_typeItem(text: types[position]),
      ));

}
