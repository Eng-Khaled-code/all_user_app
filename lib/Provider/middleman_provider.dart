import 'package:all/Models/middleman/middleman_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Services/main_operations.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MiddlemanProvider with ChangeNotifier
{

  String url=rootUrl+"middleman/";

  bool isLoading=false;
  bool isFavLoading=false;
  bool isDiscussLoading=false;
  List allList=[];
  List flatList=[];
  List blockList=[];
  List groundList=[];
  List storeList=[];
  List favList=[];
  List blackList=[];
  List discusList=[];
  List myPurchasesList=[];

  final MainOperation _mainOperation=MainOperation();

  MiddlemanProvider(){
    loadMiddlemanList("out");
  }

  Future<void> loadMiddlemanList(String from) async
  {

    if(from=="out")
    {
    isLoading=true;
    notifyListeners();
    }

    Map<String, String> postData = {"user_id": "${userInformation!.userId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "load_my_suggestion.php");
    if (resultMap["status"] == 1) {

      loadAsMiddlemanModel(resultMap["data"]);
       allList=resultMap["data"];
    } else {

      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"],),toastLength: Toast.LENGTH_LONG);
    }

    if(from=="out")
    {
    isLoading=false;
    notifyListeners();
    }
  }


  loadAsMiddlemanModel(List list)
  {
    blockList=[];
    flatList=[];
    groundList=[];
    storeList=[];
    favList=[];
    blackList=[];
    discusList=[];
    myPurchasesList=[];
    for (var element in list) {

      if(element['type']=="block"&&element['my_purchases']==0&&element['is_black']==0)
      {
        blockList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['type']=="flat"&&element['my_purchases']==0&&element['is_black']==0)
      {
        flatList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['type']=="local_store"&&element['my_purchases']==0&&element['is_black']==0)
      {
        storeList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['type']=="ground"&&element['my_purchases']==0&&element['is_black']==0)
      {
        groundList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['my_purchases']==1)
      {
        myPurchasesList.add(MiddlemanModel.fromSnapshot(element));
      }


      //loading favourates
      if(element['is_fav']==1){
        favList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['is_black']==1){
        blackList.add(MiddlemanModel.fromSnapshot(element));
      }
      //loading discuss list
      if(element['is_discuss']==1){
        discusList.add(MiddlemanModel.fromSnapshot(element));
      }

    }

    }


  search({String? searchValue})
  {
    blockList=[];
    flatList=[];
    groundList=[];
    storeList=[];
    favList=[];
    discusList=[];
    myPurchasesList=[];
    blackList=[];

    for (var element in allList) {

      if(element['type']=="block"&&element['my_purchases']==0&&element['is_black']==0&& element['address'].toString().contains(searchValue!))
      {
        blockList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['type']=="flat"&&element['my_purchases']==0&&element['is_black']==0&& element['address'].toString().contains(searchValue!))
      {
        flatList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['type']=="local_store"&&element['my_purchases']==0&&element['is_black']==0&& element['address'].toString().contains(searchValue!))
      {
        storeList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['type']=="ground"&&element['my_purchases']==0&&element['is_black']==0&& element['address'].toString().contains(searchValue!))
      {
        groundList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['my_purchases']==1&& element['address'].toString().contains(searchValue!))
      {
        myPurchasesList.add(MiddlemanModel.fromSnapshot(element));
      }

      //loading favourates
      if(element['is_fav']==1&& element['address'].toString().contains(searchValue!)){
        favList.add(MiddlemanModel.fromSnapshot(element));
      }
      else if(element['is_black']==1&& element['address'].toString().contains(searchValue!)){
        blackList.add(MiddlemanModel.fromSnapshot(element));
      }
      //loading discuss list
      if(element['is_discuss']==1&& element['address'].toString().contains(searchValue!)){
        discusList.add(MiddlemanModel.fromSnapshot(element));
      }
    }

    notifyListeners();

  }

  Future<void> favourateOperations({String? postId,String? type}) async
  {
    if(type=="black"||type=="unblack"){
      isLoading=true;
      notifyListeners();
    }else {
      isFavLoading = true;
      notifyListeners();
    }
    Map<String, String> postData = {"user_id": "${userInformation!.userId}","post_id":postId!,"type":type!};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "favourate.php");
    if (resultMap["status"] == 1) {
      await loadMiddlemanList("in");
      Fluttertoast.showToast(msg: type=="black"?"تم الاضافة في القائمة السوداء":type=="unblack"?"تم الحذف من القائمة السوداء":type=="like"?"تم الإضافة الي القائمة المفضلة":"تم الحذف من القائمة المفضلة");

    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"]));
    }
    if(type=="black"||type=="unblack"){
      isLoading=false;
      notifyListeners();
    }else{
    isFavLoading=false;
    notifyListeners();
  }}



  Future<void> discussOperation({String? postId,String? type}) async
  {

    isDiscussLoading=true;
    notifyListeners();

    Map<String, String> postData = {"user_id": "${userInformation!.userId}","post_id":postId!,"type":type!};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "discuss.php");
    if (resultMap["status"] == 1) {
      await loadMiddlemanList("in");
    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"]));
    }
    isDiscussLoading=false;
    notifyListeners();
  }

}