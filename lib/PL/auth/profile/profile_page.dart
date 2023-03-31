import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'custom_dialog.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider=Provider.of<UserProvider>(context);
    return  Directionality(
      textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: customAppbar(context: context,title:"تحديث البيانات الشخصية" ),
          body:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RefreshIndicator(
              onRefresh: ()async{
               await userProvider.phoneOperations(type:"load",phoneId:"",number:"",from: "in");
               await userProvider.countryOperations(type: "load",country: "",countryId: "",from: "in");
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    children: <Widget>[
                      const SizedBox(height: 4.0),
                      userProvider.isUsernameLoading
                          ?
                      Container(margin: const EdgeInsets.symmetric(horizontal: 10),width:25,height:25,child: const CircularProgressIndicator(color: primaryColor,strokeWidth: 0.7,))

                          : CustomText(
                       text: "${userInformation!.userName}",fontSize: 25,fontWeight: FontWeight.bold,
                      ),
                      CustomText(
                        text: "${userInformation!.email}",
                      ),
                       _nameAndAddressWidget(context,userProvider),
                       _countryWidgets(userProvider),
                      _phoneWidget(context,userProvider)

                    ],
                      ),
                ),
              ),
            ),
          ),

    );
  }

  Widget _phoneWidget(BuildContext context,UserProvider userProvider) {
    return Container(
      alignment:Alignment.centerRight,
      height: 100,
      decoration:  BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10)),
      padding:const EdgeInsets.symmetric(horizontal: 5) ,
      margin:const EdgeInsets.all(5)  ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(
          children: [
            CustomText(text:"ارقام التليفون",color: Colors.white,alignment: Alignment.centerRight,),
            const SizedBox(width :15),
            IconButton(icon:const Icon(Icons.add_ic_call_rounded,color: Colors.white,),onPressed: (){
              myCustomDialog(type: "phone",addOrUpdateOrDelete: "add",fieldValue: "",fieldId: "",context: context,userProvider: userProvider);

            },)
          ],
        ),
        userProvider.isPhoneLoading?
        Container(margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),width:25,height:25,child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 0.7,))
            :
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 30,
          child: userProvider.userPhones.isEmpty?CustomText(text:"لا يوجد",color: Colors.white,alignment: Alignment.centerRight,)
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userProvider.userPhones.length,
            itemBuilder: (context,position)=>InkWell(
              onTap: (){
                myCustomDialog(type: "phone",addOrUpdateOrDelete: "update",fieldValue: userProvider.userPhones[position]["number"],fieldId: userProvider.userPhones[position]["phone_id"].toString(),context: context,userProvider: userProvider);

              },
              child: Container(
                margin:  const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.only(left: 10),
                height: 30,
                decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   GestureDetector(child:const Icon(Icons.close,color: Colors.red,),
                      onTap: (){
                     if(userProvider.userPhones.length==1)
                     {
                       Fluttertoast.showToast(msg: "يجب ان يكون لديك علي الاقل رقم تليفون");
                     }
                     else
                       {
                       myCustomDialog(context: context,
                           userProvider: userProvider,
                           type: "phone",
                           addOrUpdateOrDelete: "delete",
                           fieldValue: userProvider
                               .userPhones[position]["number"],
                           fieldId: userProvider
                               .userPhones[position]["phone_id"].toString());
                     }},),

                    CustomText(
                      text:userProvider.userPhones[position]["number"],
                      color: Colors.white,),
                  ],
                ),),
            ),),
        )
      ],),
    );
  }

  Widget _nameAndAddressWidget(BuildContext context,UserProvider userProvider) {
    return Container(
      alignment:Alignment.centerRight,
      height: 100,
      decoration:  BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10)),
      padding:const EdgeInsets.all(5) ,
      margin:const EdgeInsets.all(5)  ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Row(
            children: [
              CustomText(text:"الاسم  ",color: Colors.white,alignment: Alignment.centerRight,),
              const SizedBox(width :15),
              userProvider.isUsernameLoading
                  ?
              Container(margin: const EdgeInsets.symmetric(horizontal: 10),width:25,height:25,child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 0.7,))

                  :
              _nameAddressField(nameOrAddress: "username",value: userInformation!.userName!,context: context,userProvider: userProvider )
            ],

          ),
           Row(
            children: [
              CustomText(text:"العنوان",color: Colors.white,alignment: Alignment.centerRight,),
              const SizedBox(width :15),
              userProvider.isAddressLoading
                  ?
              Container(margin: const EdgeInsets.symmetric(horizontal: 10),width:25,height:25,child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 0.7,))

                  :
              _nameAddressField(nameOrAddress: "address",value: userInformation!.address! ,context: context,userProvider: userProvider)
            ],

          )
        ],),
    );
  }

  Widget _nameAddressField({String? nameOrAddress,String? value,BuildContext? context,UserProvider? userProvider}) {
    return InkWell(
      onTap: (){
        myCustomDialog(type: nameOrAddress,addOrUpdateOrDelete: "update",fieldValue:value,fieldId:"",context: context,userProvider: userProvider);

      },
      child: Container(
        margin:  const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.only(left: 10,right: 10),
        height: 30,
        decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.white)),
        child: CustomText(
          text:value!,
          color: Colors.white,),),
    );

  }

  List<String> countries=["مصر","السعودية","الامارات","الكويت"];

  Widget _countryWidgets(UserProvider userProvider)=>Container(
      decoration:  BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(10)),
      padding:const EdgeInsets.only(top: 5,left: 5,right: 5) ,
      margin:const EdgeInsets.all(5)  ,
      width: double.infinity,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "الدول المستهدفة",alignment: Alignment.centerRight,color: Colors.white,),
          userProvider.isCountryLoading
              ?
          Container(margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),width:25,height:25,child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 0.7,))
              :
          SizedBox(
            height: 50,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: countries.length,
              itemBuilder: (context,position){
                Color selectColor=Colors.transparent;
                String countryId="";

                for (var element in userProvider.userCountries) {

                  if(element['country']==countries[position]){
                     selectColor=Colors.blueGrey;
                     countryId=element["country_id"].toString();
                  }

                }



                return InkWell(onTap: (){
                  if(userProvider.userCountries.length>1&&selectColor!=Colors.blueGrey){
                    Fluttertoast.showToast(msg: "لا يمكنك استهداف اكثر من دولتين");
                  }
                  else if(userProvider.userCountries.length==1&&selectColor==Colors.blueGrey){
                    Fluttertoast.showToast(msg: "يجب ان تستهدف دولة واحدة علي الاقل");
                  }
                  else
                    {

                      selectColor==Colors.blueGrey
                          ?
                       userProvider.countryOperations(type: "delete",countryId:countryId,country: "",from: "in")
                       :
                      userProvider.countryOperations(type: "add",countryId:"",country: countries[position],from: "in");
                    }
                },child: _countryItem(text: countries[position],selectionColor: selectColor));},
            ),
          ),
        ],
      ));

  Widget _countryItem({String? text,Color? selectionColor})=>  Container(
      margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: selectionColor,border: Border.all(color:Colors.white )),
              padding:const EdgeInsets.all(5),child: CustomText(text:text! ,color: Colors.white)
          );




}
