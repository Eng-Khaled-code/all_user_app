import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_button.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/PL/widgets/custom_textfield.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _txtUsername="";

  String _txtAddress="";

  String _txtCountry="مصر";

  String _txtEmail="";

  String _txtPassword="";

  String _txtPhone="";

  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider=Provider.of<UserProvider>(context);

    return WillPopScope(
       onWillPop: ()async{
         userProvider.setPage(comingPage: "log_in");
         return false;
       },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor:Colors.white,title: CustomText(text: "إنشاء حساب",alignment: Alignment.centerRight,fontSize: 18,fontWeight: FontWeight.bold,),leading:_backButton(userProvider),),
          body:  body(userProvider)));
  }

  Widget body(UserProvider userProvider ){
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(key: _formKey,child:
        userProvider.isLoading
            ?
        const Center(child: CircularProgressIndicator(),)
            :
             _fieldsWidget(userProvider)
        ,)
    ) ;
  }

  Widget _backButton(UserProvider userProvider)=>Container(margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),
      child: IconButton(icon:const Icon(Icons.arrow_back,color: primaryColor,size: 20,),onPressed:
          ()=>
         userProvider.setPage(comingPage: "log_in")

      ));

  Widget _fieldsWidget(UserProvider userProvider) {
    return SingleChildScrollView(child: Column(children: [
      CustomTextField(
        initialValue: _txtUsername,
        lable: "الاسم",
        onSave: (value){
          _txtUsername=value;
        },),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: _txtAddress,
        lable: "العنوان",
        onSave: (value){
          _txtAddress=value;
        },), const SizedBox(height: 15.0),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: _txtPhone,
        lable: "رقم التليفون",
        onSave: (value){
          _txtPhone=value;
        },), const SizedBox(height: 15.0),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: _txtEmail,
        lable: "الإيميل",
        onSave: (value){
          _txtEmail=value;
        },), const SizedBox(height: 15.0),
      const SizedBox(height: 15.0),
      CustomTextField(
        initialValue: _txtPassword,
        lable: "كلمة المرور",
        onSave: (value){
          _txtPassword=value;
        },), const SizedBox(height: 15.0),
      _countryWidget(),
      const SizedBox(height: 15.0),
      CustomButton(
          color: const[
            primaryColor,
            Color(0xFF0D47A1),
          ],
          text: "تسجيل",
          onPress: ()async{
            _formKey.currentState!.save();

            if(_formKey.currentState!.validate()){
            await userProvider.register(email:_txtEmail,password: _txtPassword,country:_txtCountry,phone:_txtPhone,address:_txtAddress,username:_txtUsername);
            }
          },
          textColor: Colors.white),
    ],),);
  }

  List<String> countries=["مصر","السعودية","الامارات","الكويت"];
  Widget _countryWidget()=>Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        CustomText(text: "الدولة التي تعيش بها",alignment: Alignment.centerRight,color: Colors.black54,),

        SizedBox(
          height: 55,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: countries.length,
            itemBuilder: (context,position){


              return InkWell(onTap: (){
                setState(() {
                  _txtCountry= countries[position];
                });
              },child: _countryItem(text: countries[position]));},
          ),
        ),
      ],
    ),
  );

  Widget _countryItem({String? text,Color? selectionColor})=>  Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: _txtCountry==text?primaryColor:Colors.transparent,border: Border.all(color:_txtCountry==text?Colors.white:Colors.grey )),
      padding:const EdgeInsets.all(8),child: CustomText(text:text! ,color:  _txtCountry==text?Colors.white:Colors.black54,)
  );
}
