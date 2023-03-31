import 'package:flutter/material.dart';

import 'constant.dart';

class CustomTextField extends StatefulWidget {
  final String? lable;
  final Color? color;
  final Function(String value)? onSave;
  final String? initialValue;
  CustomTextField({
    @required this.lable,
    @required this.onSave,
    @required this.initialValue,
    this.color=primaryColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> with SingleTickerProviderStateMixin{
  AnimationController? _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration:const Duration(
        seconds: 1,
      ),
      lowerBound: 0,
      upperBound: 1,
    )..addListener(() {
      setState(() {
      });
    });
    _controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }


  bool hidePass = true;
  IconData hidePassIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    IconData icon=
    widget.lable=="الإيميل"
        ?
    Icons.mail
        :
    widget.lable=="كلمة المرور"
        ?
    Icons.lock
        :
    widget.lable=="العنوان"||widget.lable=="البلد"||widget.lable=="المدينة"||widget.lable=="اخر مكان وجد به"
        ?
    Icons.add_location
        :
    widget.lable=="المساحة بالمتر المربع"
        ?
    Icons.ac_unit
        :
    widget.lable=="سعر المتر"
        ?
    Icons.money
        :
    widget.lable=="عدد الطوابق"||widget.lable=="رقم الطابق"||widget.lable=="العمر تقريبا"
        ?
    Icons.confirmation_number
        :
    widget.lable=="رقم التليفون"||widget.lable=="رقم تليفون اخر"
        ?
    Icons.call
        :
    widget.lable=="الاسم"||widget.lable=="اسم المريض"||widget.lable=="الاسم ان امكن"
        ?
    Icons.person
        :
    widget.lable=="تعليق"||widget.lable=="التعليق"
        ?
    Icons.message
        :
    widget.lable=="الرقم البريدي"
        ?
    Icons.credit_card
        :
        widget.lable=="الحالة الصحية"?Icons.local_hospital
            :
    Icons.more_horiz;

    TextInputType inputeType=
    widget.lable=="كلمة المرور" ?
    TextInputType.emailAddress
        :
    widget.lable=="سعر المتر"||widget.lable=="المساحة بالمتر المربع"
        ?
    const TextInputType.numberWithOptions(decimal: true)
        :
    widget.lable=="عدد الطوابق"||widget.lable=="العمر تقريبا"||widget.lable=="رقم الطابق"
        ?
    TextInputType.number
        :
    widget.lable=="رقم التليفون"||widget.lable=="رقم تليفون اخر"
        ?
    TextInputType.phone
        :
    TextInputType.text;

    return Opacity(
      opacity:_controller!.value,
      child: TextFormField(
        enabled:widget.lable=="التعليق"? false:true ,
          maxLines:widget.lable=="تعليق"||widget.lable=="التعليق"? 3:1,
          initialValue: widget.initialValue,
          keyboardType: inputeType,
          obscureText: widget.lable=="كلمة المرور"?hidePass:false,
          onSaved: (value)=> widget.onSave!(value!),
      validator:(value){

        bool isNumeric(String s) {
          if (s == null) {
            return false;
          }
          return double.tryParse(s) != null;
        }

        bool phoneValidate = (value!.startsWith("011") ||
            value.startsWith("012") ||
            value.startsWith("010") ||
            value.startsWith("015")) &&
        isNumeric(value) &&
        value.length == 11;
        if(value.isEmpty&&widget.lable!="الاسم ان امكن")
        {
        return "من فضلك إدخل "+widget.lable!;
        }

        else if(widget.lable=="الإيميل")
        {

        Pattern pattern =
        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$';

        RegExp regExp = RegExp(pattern.toString());
        if (!regExp.hasMatch(value)) return "تاكد من صحة الإيميل";
        }
        else if(widget.lable=="كلمة المرور"&&value.length<8)
        {
        return "كلمة المرور يجب الا تقل عن ثمانية احرف";
        }
        else if((widget.lable=="عدد الطوابق"||widget.lable=="رقم الطابق"||widget.lable=="العمر تقريبا")&&isNumeric(value)==false)
        {
        return "من فضلك إدخل رقم";
        }
        else if(widget.lable=="سعر المتر"&&isNumeric(value)==false)
        {
        return "من فضلك إدخل قيمة";
        }
        else if(widget.lable=="المساحة بالمتر المربع"&&isNumeric(value)==false)
        {
        return "من فضلك إدخل رقم";
        }
        else if((widget.lable=="رقم التليفون"||widget.lable=="رقم تليفون اخر")&&!phoneValidate)
        {
        return "رقم التليفون غير صحيح";
        }
      },
      style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04),
      decoration: InputDecoration(

        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(icon),
        ),
        suffixIcon:
        widget.lable=="كلمة المرور"
            ?
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon:Icon(hidePassIcon),
            onPressed: (){
              setState(() {
                if (hidePass) {
                  hidePass = false;
                  hidePassIcon = Icons.visibility;
                } else {
                  hidePass = true;
                  hidePassIcon = Icons.visibility_off;
                }
              });
            },
          ),
        )
            :
        null,
        border:OutlineInputBorder(borderRadius: BorderRadius.circular(30),),
        labelText: widget.lable,
        labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * .035,
        ),
      ),
    ),
    );
  }
}
