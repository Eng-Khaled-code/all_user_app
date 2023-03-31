import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/read_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../module_button.dart';

class BookListPage extends StatefulWidget {
  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  TextEditingController searchController = TextEditingController();
  String selectedBookCategory="الكتب";
  @override
  Widget build(BuildContext context) {
    ReadProvider doctorProvider=Provider.of<ReadProvider>(context);

    return  SafeArea(
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Column(children: [
            _buildSearchTextfieldWidget(doctorProvider),
            _typeWidgets(),
            _dataWidget(doctorProvider),
          ],),
        ),
      ),

    );}

  _dataWidget(ReadProvider readProvider){

    int itemCount=
    selectedBookCategory=="الكتب"
        ?
    readProvider.booksList.length
        :
    selectedBookCategory=="المفضلة"
        ?
    readProvider.favList.length
        :
    selectedBookCategory=="القائمة السوداء"
        ?
    readProvider.blackList.length
        :0;
    return Expanded(
        child:RefreshIndicator(
          onRefresh: ()async{
            await readProvider.loadBooksData("out");
            searchController.text="";

          },
          child:readProvider.isLoading
              ?
          loadingWidget2()
              :
          readProvider.booksList.isEmpty&&selectedBookCategory=="الكتب"? noDataCard(text: "لا توجد كتب",icon: CupertinoIcons.book):
          readProvider.favList.isEmpty&&selectedBookCategory=="المفضلة"?noDataCard(text: "لا توجد كتب في المفضلة",icon: CupertinoIcons.book):
          readProvider.blackList.isEmpty&&selectedBookCategory=="القائمة السوداء"?noDataCard(text: "لا توجد كتب في القائمة السوداء",icon: CupertinoIcons.book):

          SizedBox(
            child:
            ListView.builder(
                itemCount:itemCount,
                itemBuilder: (context,position){
                switch(selectedBookCategory)
                  {
                    case "الكتب":
                      return   ModuleButton(
                        name:readProvider.booksList[position]['name'] ,
                        imageUrl:readProvider.booksList[position]['image_url'] ,
                        bookUrl:readProvider.booksList[position]['book_url'],
                        isBlack:readProvider.booksList[position]['is_black'],
                        isFav:readProvider.booksList[position]['is_fav'],
                        likeCount:int.tryParse(readProvider.booksList[position]['like_count'])??0,
                        bookId:readProvider.booksList[position]['id'],

                      );
                    case "المفضلة":
                      return  ModuleButton(
                        name:readProvider.favList[position]['name'] ,
                        imageUrl:readProvider.favList[position]['image_url'] ,
                        bookUrl:readProvider.favList[position]['book_url'],
                        isBlack:readProvider.favList[position]['is_black'],
                        isFav:readProvider.favList[position]['is_fav'] ,
                        likeCount:int.tryParse(readProvider.favList[position]['like_count'])??0,
                        bookId:readProvider.favList[position]['id'],

                      );
                      case "القائمة السوداء":
                      return  ModuleButton(
                        name:readProvider.blackList[position]['name'] ,
                        imageUrl:readProvider.blackList[position]['image_url'],
                        bookUrl:readProvider.blackList[position]['book_url'],
                        isBlack:readProvider.blackList[position]['is_black'],
                        isFav:readProvider.blackList[position]['is_fav'],
                        likeCount:int.tryParse(readProvider.blackList[position]['like_count'])??0,
                        bookId:readProvider.blackList[position]['id'],

                      );
                    default:
                     return Container();
                }}

            ),
          ),
        ));
  }

  Widget _buildSearchTextfieldWidget(ReadProvider readProvider) {
    return Container(
      margin:const EdgeInsets.all( 10),
      decoration: BoxDecoration(
          border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        onChanged: (value) {
          readProvider.loadAndSearch(searchValue: value,type: "search");
        },
        style:const TextStyle(color: Colors.grey, fontSize: 14),
        controller: searchController,
        decoration:const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: " بحث  باسم الكتاب ...",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            )),
      ),
    );
  }

  List<String> types=["الكتب","المفضلة","القائمة السوداء"];

  Widget _typeItem({String? text})=>InkWell(
      onTap: ()=> setState(()=> selectedBookCategory=text!)
      ,
      child: Container(padding:const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: text==selectedBookCategory?primaryColor:Colors.transparent),
          child: CustomText(text:text! ,color: text==selectedBookCategory?Colors.white:Colors.black,alignment: Alignment.topCenter,)
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
