import 'dart:convert';
import 'dart:io';
import 'package:all/Models/mps/found_model.dart';
import 'package:all/Models/mps/missed_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Services/main_operations.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class MPSProvider with ChangeNotifier
{

  String url=rootUrl+"mps/";
  bool isLoading=false;
  List<MissedModel> waitingMissedList=[];
  List<MissedModel> acceptedMissedList=[];
  List<MissedModel> refusedMissedList=[];
  List<MissedModel> waitingFoundList=[];
  List<MissedModel> acceptedFoundList=[];
  List<MissedModel> refusedFoundList=[];

  List<FoundModel> foundList=[];
  List<FoundModel> helpToFoundList=[];
  final MainOperation _mainOperation=MainOperation();

  MPSProvider(){
    loadMPSData("out");
  }

  Future<void> loadMPSData(String from) async {

    if(from=="out")
    {
    isLoading=true;
    notifyListeners();
    }

    Map<String, String> postData = {"user_id": "${userInformation!.userId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "load_missed_people.php");
    if (resultMap["status"] == 1) {
      loadMpsAsModel(missed:resultMap['data'],found:resultMap['found']);
    } else {
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"],),toastLength: Toast.LENGTH_LONG);
    }

    if(from=="out")
    {
    isLoading=false;
    notifyListeners();
    }
  }

  loadMpsAsModel({List? missed,List? found}) {
    waitingMissedList=[];
    acceptedMissedList=[];
    refusedMissedList=[];
    waitingFoundList=[];
    acceptedFoundList=[];
    refusedFoundList=[];
    foundList=[];
    helpToFoundList=[];

    for(var item in missed!)
    {
      if(item['missed_type']=="فقد"&&item['missed_status']=='انتظار'){
        waitingMissedList.add(MissedModel.fromSnapshot(item));}
      else if(item['missed_type']=="فقد"&&item['missed_status']=='مقبول'){
        acceptedMissedList.add(MissedModel.fromSnapshot(item));}
      else if(item['missed_type']=="فقد"&&item['missed_status']=='مرفوض'){
        refusedMissedList.add(MissedModel.fromSnapshot(item));}
      else if(item['missed_type']=="إيجاد"&&item['missed_status']=='انتظار'){
        waitingFoundList.add(MissedModel.fromSnapshot(item));}
      else if(item['missed_type']=="إيجاد"&&item['missed_status']=='مقبول'){
        acceptedFoundList.add(MissedModel.fromSnapshot(item));}
      else if(item['missed_type']=="إيجاد"&&item['missed_status']=='مرفوض'){
        refusedFoundList.add(MissedModel.fromSnapshot(item));}
  }


    for(var item in found!)
    {
      if(item['user_id']==userInformation!.userId){
        foundList.add(FoundModel.fromSnapshot(item));}
      else if(item['f_user_id']==userInformation!.userId){
        helpToFoundList.add(FoundModel.fromSnapshot(item));}
    }
  }



  Future<bool> missedOperations({
    String? addOrUpdateOrDelete="",
    String? missedOrFound="",
    XFile? imageXfile=null,
    String?imageUrl="",
    String? helthyStatus="",
    String? name="",
    String? sex="",
    int? age=0,
    String? lastPlace="",
    String? faceColor="",
    String? hairColor="",
    String? eyeColor="",
    String? missedStatus="انتظار",
    int? id=0,
  }) async {

    isLoading=true;
    notifyListeners();
    String imageName=imageXfile !=null?imageXfile.path.split("/").last:imageUrl!.split("/").last;
    String base64 = imageXfile !=null?base64Encode(File(imageXfile.path).readAsBytesSync()):"";

   /* print(imageXfile != null&&addOrUpdateOrDelete!="add"?(imageUrl!.split("/").last):"no");
    print(missedOrFound=="فقد"?"missed":"found");
    print(missedStatus);
    print(missedStatus=="انتظار"?"waiting":missedStatus=="مقبول"?"accept":"refuse");
    */
   Map<String, String> postData =
    {
    "type": addOrUpdateOrDelete!,
    "name": name!,
    "missed_or_found":missedOrFound!,
    "user_id": "${userInformation!.userId}",
    "sex": sex!,
    "helthy_status": helthyStatus!,
    "age": "$age",
    "last_place": lastPlace!,
    "face_color":faceColor!,
    "hair_color":hairColor!,
    "eye_color":eyeColor!,
    "status_after_update":"انتظار",
    "image_name":imageName,
    "old_image_name": imageXfile != null&&addOrUpdateOrDelete!="add"?(imageUrl!.split("/").last):"no",
    "base64":base64,
    "id": "$id",
    "missed_or_found_english":missedOrFound=="فقد"?"missed":"found",
    "missed_status":missedStatus=="انتظار"?"waiting":missedStatus=="مقبول"?"accept":"refuse"
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
    postData, url + "missed_operations.php");
    if (resultMap["status"] == 1) {
    await loadMPSData("in");

    Fluttertoast.showToast(msg:addOrUpdateOrDelete=="add"?"تمت الإضافة بنجاح":addOrUpdateOrDelete=="update"?"تم التعديل بنجاح":"تم الحذف بنجاح");
    isLoading=false;
    notifyListeners();
    return true;
    } else {
      print(resultMap["message"]);
    Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),toastLength: Toast.LENGTH_LONG);
    isLoading=false;
    notifyListeners();
    return false;

    }

  }


  Future<void> suggetionTrue({int? messedId,int? foundId})async{


    isLoading=true;
    notifyListeners();

    Map<String, String> postData =
    {
      "type": "suggest true",
      "id1": "$messedId",
      "id2":"$foundId",
      "image_name":""
  };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "suggestions.php");
    if (resultMap["status"] == 1) {
      await loadMPSData("in");
      Fluttertoast.showToast(msg:"تم العثور علي الشخص بنجاح");

    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),toastLength: Toast.LENGTH_LONG);
    }
    isLoading=false;
    notifyListeners();

}}