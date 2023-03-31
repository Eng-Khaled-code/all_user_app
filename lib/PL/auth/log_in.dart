
import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/PL/widgets/custom_textfield.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LogIn extends StatelessWidget {

  final _formKey=GlobalKey<FormState>();
   String? _txtUsername;
   String? _txtPassword;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider=Provider.of<UserProvider>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child:SingleChildScrollView(
                  physics:const AlwaysScrollableScrollPhysics(),

                  child:  Column(
                children: [
                ClipRRect(borderRadius:const BorderRadius.only(bottomRight:Radius.circular(20) ,bottomLeft: Radius.circular(20) ),child: Image.asset("assets/images/icon.jpg", fit: BoxFit.fill,)),
                 userProvider.isLoading|| userProvider.error!=null?loading(userProvider): dataColumn(userProvider,context)
                ],
              )),
        ),
      ),
      ),
    );

  }

  Widget loading(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0,left: 10,right: 10),
      child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userProvider.isLoading?loadingWidget2()!
             :
           Container(),
    InkWell(onTap:()async{
    if(userProvider.error  !=null){

      SharedPreferences prefs=await SharedPreferences.getInstance();

    if(prefs.getString("user_id") != null &&prefs.getString("user_id")!=""){
    await userProvider.openMyHomePage(email:"",password: "",type: "load",userId:prefs.getString("user_id"));
    }
    }
    },child: userProvider.isLoading?Container(): CustomText(text:userProvider.error==null? "إنتظر لحظة":(userProvider.error! +" \n إضغط للتحديث"),maxLine: 7,))]),
    );
  }

  Widget dataColumn(UserProvider userProvider,BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0, vertical: 40.0),
      child: Column(children: [
        CustomTextField(
          lable: "الإيميل",
          initialValue: _txtUsername,
          onSave: (value){
            _txtUsername=value;
          },),
        const SizedBox(height: 15.0),
        CustomTextField(
          lable: "كلمة المرور",
          initialValue: _txtPassword,
          onSave: (value){
            _txtPassword=value;
          },),
        const SizedBox(height: 15.0),
         __buildForgetPasswordWidget(),
        const SizedBox(height: 15.0),
        CustomButton(
            color: const[
              primaryColor,
              Color(0xFF0D47A1),
            ],
            text: "تسجيل الدخول",
            onPress: ()async{
              _formKey.currentState!.save();

              if(_formKey.currentState!.validate()){
                  await userProvider.openMyHomePage(email:_txtUsername,password: _txtPassword,type: "log_in",userId:"");
              }

            },
            textColor: Colors.white),
        const SizedBox(height: 30.0),
        __buildConnectUsWidget(userProvider)
      ],),
    );
  }

  Widget __buildForgetPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child:  CustomText(
         text: "هل نسيت كلمة المرور؟",
              fontSize: 14,
        ),
        onPressed: () {
          //goTo(context: context,to:ForgetPassword());
        },
      ),
    );
  }

  Widget __buildConnectUsWidget(UserProvider userProvider) {
    return TextButton(
      child:CustomText(
        text:"إنشاء حساب",
            fontSize:16,
        color: Colors.orange,
      ),
      onPressed:()=> userProvider.setPage(comingPage: "register"),
    );
  }

}