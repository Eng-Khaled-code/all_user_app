import 'package:all/PL/home/mps/add_missed/widgets/custom_dropdown_button.dart';
import 'package:all/PL/home/mps/add_missed/widgets/sex_widget.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_textfield.dart';
import 'package:all/Provider/mps_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:all/PL/home/mps/add_missed/widgets/missed_image.dart';

import '../mps_constant.dart';
class AddMissed extends StatelessWidget {
  AddMissed({Key? key,this.id,this.lastPlace,this.name,this.missedStatus,this.eyeColor,this.hairColor,this.helthyStatus,this.faceColor,this.age,this.sex,this.imageUrl,this.addOrUpdate,this.messedOrFound}) :super(key: key);
   String? addOrUpdate="إضافة";
   int? id=0;
   int? age=0;
   String? messedOrFound="";
   String? helthyStatus="";
   String? name="";
   String? sex="";
  String? lastPlace="";
  String? faceColor="";
  String? hairColor="";
  String? eyeColor="";
  String? missedStatus="انتظار";
  String? imageUrl="";
  final _formKey = GlobalKey<FormState>();
  List<String> faceColorList = ["اختر واحدة", "غامق", "أسمر", "أبيض"];
  List<String> hairColorList = ["اختر واحدة", "أسود", "أصفر", "يحتوي أبيضي"];
  List<String> eyeColorList = [
    "اختر واحدة",
    "أسود",
    "أزرق",
    "أخضر",
    "عسلي",
    "رمادي"
  ];
  @override
  Widget build(BuildContext context) {
    MPSProvider mpsProvider=Provider.of<MPSProvider>(context);
    if(addOrUpdate == "تعديل" ){
    selectedFaceColor=faceColor!;
    selectedHairColor=hairColor!;
    selectedEyeColor =eyeColor!;
    selectedSex=sex!;
    imagePath=imageUrl;

    }
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: customAppbar(context: context,title:addOrUpdate),
      body: Form(
              key: _formKey,
              child: mpsProvider.isLoading ? const Center(
                child: CircularProgressIndicator(),) : SingleChildScrollView(
                child: Column(
                  children:[
                    const SizedBox(height: 15.0),
                    MissedImage(),
                     const SizedBox(height: 15.0),
                                                   SexWidget(),
                    const SizedBox(height: 15.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                messedOrFound=="فقد"?CustomTextField(
                                  initialValue: name,
                                  lable: "الاسم",
                                  onSave: (value) {
                                   name=value;
                                  },):CustomTextField(
                                  initialValue: name,
                                  lable  :"الاسم ان امكن",
                                  onSave: (value) {
                                    name=value;
                                  },), const SizedBox(height: 15.0),
                                CustomTextField(
                                  initialValue: age==null?"":age.toString(),
                                  lable: "العمر تقريبا",
                                  onSave: (value) {
                                  age=int.tryParse(value);
                                  },),
    const SizedBox(height: 15.0),

                                CustomTextField(
                                  initialValue: lastPlace,
                                  lable: "اخر مكان وجد به",
                                  onSave: (value) {
                                   lastPlace= value;
                                  },),
                                const SizedBox(height: 15.0),
                                CustomTextField(
                                  initialValue:helthyStatus,
                                  lable: "الحالة الصحية",
                                  onSave: (value) {
                                  helthyStatus=value;
                                  },),
                                CustomDropdownButton(
                                    items: faceColorList,
                                    lable: "لون البشرة"),
                                CustomDropdownButton(
                                    items: hairColorList, lable: "لون الشعر"),
                                CustomDropdownButton(
                                    items: eyeColorList, lable: "لون العين"),
                                const SizedBox(height: 25.0),
                                CustomButton(
                                    color: const[
                                      primaryColor,
                                      Color(0xFF0D47A1),
                                    ],
                                    text: addOrUpdate,
                                    onPress: ()async {
                                      _formKey.currentState
                                      !.save();
                                      bool imageCondation=
                                      (imageFile==null&&addOrUpdate=="إضافة")
                                      ||
                                      (addOrUpdate=="تعديل"&&(imageFile==null&&imagePath==""));
                                      if(  imageCondation )
                                      {
                                        Fluttertoast.showToast(msg:"يجب ان تختار صورة للمفقود");
                                      }
                                      else if(selectedFaceColor=="اختر واحدة"||selectedHairColor=="اختر واحدة"||selectedEyeColor=="اختر واحدة")
                                      {
                                      Fluttertoast.showToast(msg:"يجب ان تكمل باقي البيانات");

                                      }
                                      else if(_formKey.currentState!.validate()){
    if(await mpsProvider.missedOperations(
                                      addOrUpdateOrDelete:addOrUpdate=="إضافة"?"add":"update",
                                      missedOrFound:messedOrFound,
                                      imageXfile:imageFile,
                                      imageUrl:imageUrl,
                                      faceColor:selectedFaceColor,
                                      name:name,
                                      age:age,
                                      sex:selectedSex,
                                      helthyStatus:helthyStatus,
                                      lastPlace:lastPlace,
                                      id:id,
                                      hairColor:selectedHairColor,
                                      eyeColor:selectedEyeColor,
                                      missedStatus:missedStatus,

                                      )){
      Navigator.pop(context);
    }
                                      }
                                    },
                                    textColor: Colors.white),
                              ],
                            ),
                          ),


                  ],),
              ),
            ),
    ),
  );
  }

}