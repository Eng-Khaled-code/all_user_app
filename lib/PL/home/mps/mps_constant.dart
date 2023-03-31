import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
int currentIndex = 0;
String selectedFaceColor="اختر واحدة";
String selectedHairColor="اختر واحدة";
String selectedEyeColor="اختر واحدة";
String selectedSex="ذكر";
XFile? imageFile;
String? imagePath="";


loadingMpsWidget() {
  return Container(margin:const EdgeInsets.all(50),height:20,width:20,child:const CircularProgressIndicator(strokeWidth: 2,));
}