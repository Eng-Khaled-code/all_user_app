import 'package:all/Models/courses/course_model.dart';
import 'package:all/PL/home/courses/course_page/course_card.dart';
import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Provider/courses_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../courses_const.dart';
class CoursesPage extends StatefulWidget {

  final String? page;
  CoursesPage({Key? key,this.page}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CourseProvider courseProvider=Provider.of<CourseProvider>(context);

    return  SafeArea(
        child:  Column(children: [
         _buildSearchTextfieldWidget(courseProvider),
         widget.page=="courses_list"?  categoryWidgets(onTap:(){
              setState((){});
              courseProvider.loadAndSearch(searchValue: searchController.text);
            }):Container(),
            _dataWidget(courseProvider),
          ],),
      );}

  _dataWidget(CourseProvider courseProvider){
    int itemCount=widget.page=="courses_list"?courseProvider.coursesList.length:widget.page=="fav_list"?courseProvider.favList.length:widget.page=="black_list"?courseProvider.blackList.length:0;
    return Expanded(child: RefreshIndicator(
        onRefresh: ()async{
          await courseProvider.loadCoursesList("in");

        },
        child:courseProvider.isLoading
        ?
    loadingWidget2()
        :
    widget.page=="courses_list"&&(courseProvider.coursesList.isEmpty||_checkEmpty(courseProvider)) ? noDataCard(text: "لا توجد كورسات",icon:CupertinoIcons.book)
        :
    widget.page=="fav_list"&&courseProvider.favList.isEmpty?   noDataCard(text: "لا توجد كورسات في قائمة المفضلة",icon: Icons.favorite)
        :
    widget.page=="black_list"&&courseProvider.blackList.isEmpty? noDataCard(text: "لا توجد كورسات في القائمة السوداء",icon: Icons.visibility_off)
        :
    widget.page=="my_courses_list"&&courseProvider.myCourses.isEmpty? noDataCard(text: "لا توجد كورسات",icon: CupertinoIcons.book)
        :
    SizedBox(
      child:
      ListView.builder(
          itemCount:itemCount,
          itemBuilder: (context,position){
            CourseModel _model=widget.page=="courses_list"?courseProvider.coursesList[position]:widget.page=="fav_list"?courseProvider.favList[position]:widget.page=="black_list"?courseProvider.blackList[position]:courseProvider.myCourses[position];
            return widget.page !="courses_list"?CourseCard(model:_model,courseProvider: courseProvider):widget.page=="courses_list"&&courseSelectedCategory==_model.category?CourseCard(model:_model,courseProvider: courseProvider):Container();
          }

      ),
    )));
  }

  bool _checkEmpty(CourseProvider courseProvider){
    bool value=false;
    for (var element in courseProvider.coursesList) {
      value=element.category==courseSelectedCategory?false:true;
      if(value==false){
        break;}
    }
    return value;
  }

  Widget _buildSearchTextfieldWidget(CourseProvider courseProvider) {
    return Container(
      margin:const EdgeInsets.all( 10),
      decoration: BoxDecoration(
          border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        onChanged: (value) {
          courseProvider.loadAndSearch(searchValue: value);
        },
        style:const TextStyle(color: Colors.grey, fontSize: 14),
        controller: searchController,
        decoration:const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: " بحث ...",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            )),
      ),
    );
  }
}