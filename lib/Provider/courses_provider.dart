import 'package:all/Models/courses/course_model.dart';
import 'package:all/PL/home/courses/courses_const.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Services/main_operations.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CourseProvider with ChangeNotifier
{

  String url=rootUrl+"courses/";
  bool isLoading=false;
  bool isFavLoading=false;
  List<CourseModel> coursesList=[];
  List allCoursesList=[];
  List<CourseModel> favList=[];
  List<CourseModel> blackList=[];
  List<CourseModel> myCourses=[];

  final MainOperation _mainOperation=MainOperation();

  CourseProvider(){
    loadCoursesList("out");
  }

  Future<void> loadCoursesList(String from) async {

    if(from=="out")
    {
    isLoading=true;
    notifyListeners();
    }

    Map<String, String> postData = {"user_id": "${userInformation!.userId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "load_suggested_courses.php");
    if (resultMap["status"] == 1) {

      courseCategoriesList=resultMap["categories"];
      if(from!="in") {
        courseSelectedCategory =
        courseCategoriesList.isNotEmpty ? courseCategoriesList.first : "";
      }
      allCoursesList=resultMap["data"];

      loadAndSearch(searchValue: "");

    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"],),toastLength: Toast.LENGTH_LONG);
    }

    if(from=="out")
    {
    isLoading=false;
    notifyListeners();
    }
  }


  loadAndSearch({ String? searchValue}) {
    coursesList=[];
    favList=[];
    blackList=[];
    myCourses=[];

    if(searchValue=="")
    {
      for (var element in allCoursesList) {
        if(element['is_black']==0){
          if(element['is_fav']==1)
           {
          favList.add(CourseModel.fromSnapshot(element));
           }
          coursesList.add(CourseModel.fromSnapshot(element));
        }
        else if(element['is_black']==1){
          blackList.add(CourseModel.fromSnapshot(element));
         }


      }
    }
    else
    {
      for (var element in allCoursesList) {
          if(element['is_black']==0&&element['category']==courseSelectedCategory&&element['name'].toString().contains(searchValue!))
          {
            coursesList.add(CourseModel.fromSnapshot(element));
          }
          else if(element['is_black']==1&&element['name'].toString().contains(searchValue!))
          {
           blackList.add(CourseModel.fromSnapshot(element));
          }

    if(element['is_fav']==1&&element['name'].toString().contains(searchValue!))
    {
    favList.add(CourseModel.fromSnapshot(element));
    }
      }
    }


  notifyListeners();
  }

  Future<void> favourateOperations({String? courseId,String? type}) async {
    if(type=="black"||type=="unblack"){
      isLoading=true;
      notifyListeners();
    }
    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "course_id": courseId!,
      "type": type!
    };
    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "favourate.php");
    if (resultMap["status"] == 1) {
      await loadCoursesList("in");
      Fluttertoast.showToast(msg: type=="black"?"تم الاضافة في القائمة السوداء":type=="unblack"?"تم الحذف من القائمة السوداء":type=="like"?"تم الإضافة الي القائمة المفضلة":"تم الحذف من القائمة المفضلة");

    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
    }

    if(type=="black"||type=="unblack"){
      isLoading=false;
      notifyListeners();
    }

  }}


