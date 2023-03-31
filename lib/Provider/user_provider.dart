import 'package:all/Models/user/user_model.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Services/main_operations.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier{

  String url=rootUrl+"auth/";
  bool isLoading=false;
  String? error;
  String page='log_in';
  SharedPreferences? prefs;
  List userPhones=[];
  List userCountries=[];
  List userComments=[];
  bool isPhoneLoading=false;
  bool isUsernameLoading=false;
  bool isAddressLoading=false;
  bool isCountryLoading=false;
  bool isCommentLoading=false;

  final MainOperation _mainOperation=MainOperation();

  UserProvider(){
    checkLogIn();
    }

  Future<void> checkLogIn()async{
      prefs=await SharedPreferences.getInstance();

    if(prefs!.getString("user_id") != null &&prefs!.getString("user_id")!=""){
      await openMyHomePage(email:"",password: "",type: "load",userId:prefs!.getString("user_id"));
    }

   }

  Future<void> openMyHomePage({String? email, String? password,String? type,String? userId}) async {
  isLoading = true;
  notifyListeners();
 // await FirebaseMessaging.instance.getToken().then((String? token)async{

    Map<String, String> postData = {"email": email!, "password": password!,"type":type!,"user_type":"user","user_id":userId!,"token":"test"};


    Map<String, dynamic> resultMap =await _mainOperation.postOperation(postData, url + "on_app_start.php");

    if (resultMap["status"] == 1) {

    if(type!="load") {
      prefs = await SharedPreferences.getInstance();
      prefs!.setString("user_id", "${resultMap["data"]["user_id"]}");
    }

    userInformation=UserModel.fromSnapshot(resultMap["data"]);

    await phoneOperations(type:"load",phoneId:"",number:"",from:"out");
    await countryOperations(type:"load",countryId:"",country:"",from: "out");
    await getComments("out");
    page="home";
    isLoading=false;
    Fluttertoast.showToast(msg:"تم تسجيل الدخول بنجاح");
    notifyListeners();

    } else {

    if(type=="load")
      {
        error = resultMap["message"];
      }
    else
      {
        Fluttertoast.showToast(msg:resultMap["message"]);
      }

    isLoading=false;
    notifyListeners();
    }


 /* }).catchError(( comingError){
      error = comingError;
      isLoading=false;
      notifyListeners();
      return false;

  });
*/
}

  Future<void> register({String? email, String? password,String? username,String? country,String? phone,String? address}) async {
    isLoading = true;
    notifyListeners();
    // await FirebaseMessaging.instance.getToken().then((String? token)async{

    Map<String, String> postData = {"email": email!, "password": password!,
      "address":address!,"user_type":"user","username":username!,"phone":phone!,"country":country!,"token":"test"};


    Map<String, dynamic> resultMap =await _mainOperation.postOperation(postData, url + "add_user.php");
    print(resultMap);

    if (resultMap["status"] == 1) {

        prefs = await SharedPreferences.getInstance();
        prefs!.setString("user_id", "${resultMap["data"]["user_id"]}");


    userInformation=UserModel.fromSnapshot(resultMap["data"]);

    await phoneOperations(type:"load",phoneId:"",number:"",from:"out");
    await countryOperations(type:"load",countryId:"",country:"",from: "out");

    page="home";
    isLoading=false;
    Fluttertoast.showToast(msg:"تم إنشاء الحساب بنجاح");
    notifyListeners();

    } else {

    Fluttertoast.showToast(msg:resultMap["message"]=="email already exist"?"هذا الإيميل موجود بالفعل":resultMap["message"]);

    isLoading=false;
    notifyListeners();
    }

    /* }).catchError(( comingError){
      error = comingError;
      isLoading=false;
      notifyListeners();
      return false;

  });
*/
  }

  Future<void> logOut()async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString("user_id", "");
    page="log_in";
    notifyListeners();
  }

  Future<void> phoneOperations({String? type,String? phoneId,String? number,String? from})async{
    if(from=="in"){
    isPhoneLoading=true;
    notifyListeners();}
    Map<String, String> postData =
    {
      "user_id": userInformation!.userId.toString(),
      "type":type!,
      "phone_id":phoneId!,
      "number":number!
    };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "phone_operation.php");
    if (resultMap["status"] == 1) {

      userPhones=resultMap["data"];
      if(type!="load") {
        Fluttertoast.showToast(msg:type=="add"? "تمت اضافة الهاتف بنجاح":type=="update"?"تم تعديل الهاتف بنجاح":"تم حذف الهاتف بنجاح");
      }
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
          );
    }

    if(from=="in"){
    isPhoneLoading=false;
    notifyListeners();}
  }

  Future<void> countryOperations({String? type,String? countryId,String? country,String? from})async{
    if(from=="in"){
    isCountryLoading=true;
    notifyListeners();}

    Map<String, String> postData =
    {
      "user_id": userInformation!.userId.toString(),
      "type":type!,
      "country_id":countryId!,
      "country":country!
    };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "country_operation.php");
    if (resultMap["status"] == 1) {

      userCountries=resultMap["data"];
      if(type!="load") {
        Fluttertoast.showToast(msg:type=="add"? "تمت اضافة الدولة بنجاح":type=="update"?"تم تعديل الدولة بنجاح":"تم حذف الدولة بنجاح");
      }
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
         );
    }
    if(from=="in"){
    isCountryLoading=false;
    notifyListeners();}
  }

  Future<void> updateUserFields({String? key,String? value})async{

    key=="username"
        ?
    isUsernameLoading=true
        :
    isAddressLoading=true;
    notifyListeners();
    Map<String, String> postData =
    {
      "user_id": userInformation!.userId.toString(),
      "key":key!,
      "value":value!,
    };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "update_user.php");
    if (resultMap["status"] == 1) {

      userInformation=UserModel.fromSnapshot(resultMap["data"]);
      Fluttertoast.showToast(msg:key=="username"?"تم تعديل الاسم بنجاح":"تم تعديل العنوان بنجاح");
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
        );
    }

    key=="username"
        ?
    isUsernameLoading=false
        :
    isAddressLoading=false;
   notifyListeners();
  }

  Future<void> getComments(String from)async{
    if(from=="in"){
    isCommentLoading=true;
    notifyListeners();}
    Map<String, String> postData =
    {
      "user1_id": userInformation!.userId.toString(),
      "type":"load",
      "user2_id":"",
      "comment":"",
      "rate":"",
      "user_type":"user"
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "get_comments.php");
    if (resultMap["status"] == 1) {

      userComments=resultMap["data"];
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),
          toastLength: Toast.LENGTH_LONG,
         );
    }
    if(from=="in"){
      isCommentLoading=false;
    notifyListeners();
    }
  }

  Future<void> commentOperations({String? type,String? newMessage,String? newRate,String? otherUserId})async{

    isCommentLoading=true;
    notifyListeners();

    Map<String, String> postData =
    {
      "user1_id": userInformation!.userId.toString(),
      "type":type!,
      "user2_id":otherUserId!,
      "comment":newMessage!,
      "rate":newRate!,
      "user_type":"user"
    };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "get_comments.php");
    if (resultMap["status"] == 1) {

        userComments=resultMap["data"];
        Fluttertoast.showToast(msg:type=="add"? "تمت اضافة التقييم بنجاح":type=="update"?"تم تعديل التقييم بنجاح":"تم حذف التقييم بنجاح");
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]),
        toastLength: Toast.LENGTH_LONG,
      );
    }
    isCommentLoading=false;
    notifyListeners();


  }

  setPage({String? comingPage}) {
    page=comingPage!;
    notifyListeners();
  }

}
