import 'package:all/Models/ecommerce/address_model.dart';
import 'package:all/Models/doctor/booking_model.dart';
import 'package:all/Models/doctor/doctor_model.dart';
import 'package:all/Models/middleman/middleman_model.dart';
import 'package:all/Models/ecommerce/order_model.dart';
import 'package:all/Models/ecommerce/product_model.dart';
import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Services/main_operations.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadProvider with ChangeNotifier
{

  String url=rootUrl+"read_books/";
  bool isLoading=false;
  bool isFavLoading=false;

  List allBooksList=[];
  List booksList=[];
  List favList=[];
  List blackList=[];

  final MainOperation _mainOperation=MainOperation();

  ReadProvider(){
    loadBooksData("out");
  }

  Future<void> loadBooksData(String type) async {

    if(type!="in") {
      isLoading = true;
      notifyListeners();
    }
    Map<String, String> postData = {"type": "load","book_name":"","book_url":"","image_url":"","book_id":"","user_id":userInformation!.userId.toString()};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "books_admin.php");
    if (resultMap["status"] == 1) {
      allBooksList=resultMap["data"];
      loadAndSearch(searchValue: "",type: "load");
    } else {
      print(resultMap["message"]);
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"],),toastLength: Toast.LENGTH_LONG);
    }
    if(type!="in") {

    isLoading=false;
    notifyListeners();}

  }

  loadAndSearch({String? searchValue,String? type}){
    booksList=[];
    favList=[];
    blackList=[];
    if(searchValue==""){
      for(var book in allBooksList)
      {

        if(book['is_black']==1)
        {
          blackList.add(book);
        }
        else
       {
            booksList.add(book);
        }

        if(book['is_fav']==1)
        {
          favList.add(book);
        }
      }
    }
    else{
      for(var book in allBooksList)
      {
        if(book['is_black']==1&&book['name'].toString().contains(searchValue!))
        {
          blackList.add(book);
        }
        else if(book['is_black']==0&&book['name'].toString().contains(searchValue!))
        {
          booksList.add(book);
        }
        if(book['is_fav']==1&&book['name'].toString().contains(searchValue!)){
          favList.add(book);
        }
      }
    }
    if(type!="load")notifyListeners();
  }


  Future<void> favourateOperations({String? postId,String? type}) async {
    if(type=="black"||type=="unblack"){
      isLoading=true;
      notifyListeners();
    }else {
      isFavLoading = true;
      notifyListeners();
    }
    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "book_id": postId!,
      "type": type!
    };
    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "favourate.php");
    if (resultMap["status"] == 1) {
      await loadBooksData("in");
      Fluttertoast.showToast(msg: type=="black"?"تم الاضافة في القائمة السوداء":type=="unblack"?"تم الحذف من القائمة السوداء":type=="like"?"تم الإضافة الي القائمة المفضلة":"تم الحذف من القائمة المفضلة");

    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
    }

    if(type=="black"||type=="unblack"){
      isLoading=false;
      notifyListeners();
    }else {
      isFavLoading = false;
      notifyListeners();
    }

  }
}