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

class DoctorProvider with ChangeNotifier
{

  String url=rootUrl+"doctors/";
  bool isLoading=false;
  List<DoctorModel> doctorsList=[];
  List allDoctorsList=[];
  List<BookingModel> waitingBookingList=[];
  List<BookingModel> acceptedBookingList=[];
  List<BookingModel> refusedBookingList=[];
  List<BookingModel> finishedBookingList=[];
  List<BookingModel> canceledBookingList=[];

  final MainOperation _mainOperation=MainOperation();

  DoctorProvider(){
    loadDoctorsData("out");
  }

  Future<void> loadDoctorsData(String from) async {

    if(from=="out")
    {
    isLoading=true;
    notifyListeners();
    }

    Map<String, String> postData = {"user_id": "${userInformation!.userId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "suggested_doctors.php");
    if (resultMap["status"] == 1) {

      allDoctorsList=resultMap["data"];
      loadAndSearch(searchValue: "");
      loadBookingsAsModel(myBookings:resultMap['my_bookings'] );
    } else {
      print(resultMap["message"]);
      Fluttertoast.showToast(msg:errorTranslation(resultMap["message"],),toastLength: Toast.LENGTH_LONG);
    }

    if(from=="out")
    {
    isLoading=false;
    notifyListeners();
    }
  }

  loadBookingsAsModel({List? myBookings}) {
     waitingBookingList=[];
     acceptedBookingList=[];
     refusedBookingList=[];
     finishedBookingList=[];
     canceledBookingList=[];

    for(var book in myBookings!)
    {
      if(book['booking_status']=="WAITING"){
        waitingBookingList.add(BookingModel.fromSnapshot(book));}
      else if(book['booking_status']=="ACCEPTED"){
        acceptedBookingList.add(BookingModel.fromSnapshot(book));}
      else if(book['booking_status']=="REFUSED"){
        refusedBookingList.add(BookingModel.fromSnapshot(book));}
      else if(book['booking_status']=="CANCELED"){
        canceledBookingList.add(BookingModel.fromSnapshot(book));}
      else if(book['booking_status']=="FINISHED"){
        finishedBookingList.add(BookingModel.fromSnapshot(book));}
  }


  }

  loadAndSearch({ String? searchValue}) {
    doctorsList=[];
    if(searchValue=="")
    {
      for (var element in allDoctorsList) {
       doctorsList.add(DoctorModel.fromSnapshot(element));
      }
    }
    else
    {
      for (var element in allDoctorsList) {
          if(element['about'].toString().contains(searchValue!))
          {
            doctorsList.add(DoctorModel.fromSnapshot(element));
          }
      }
    }


  notifyListeners();
  }

  Future<bool> bookingOperations({int? bookingId=0 ,int? docId=0,String? patientName="",String? painDesc="",String? type}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {
      "user_id": "${userInformation!.userId}",
      "book_id": "$bookingId",
      "type": type!,
      "pain_desc":painDesc!,
      "patient_name":patientName!,
      "doc_id":"$docId"
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "main_booking_operatios.php");
    if (resultMap["status"] == 1) {
      await loadDoctorsData("in");
      if(type!="load") {
        Fluttertoast.showToast(
            msg: type == "add" ? "تم الحجز بنجاح" : type == "delete"
                ? "تم الحذف بنجاح"
                : "تم التعديل بنجاح");
      }isLoading=false;
      notifyListeners();
      return true;
    } else {
      Fluttertoast.showToast(msg: errorTranslation(resultMap["message"]));
      isLoading=false;
      notifyListeners();
      return false;
    }




  }


}