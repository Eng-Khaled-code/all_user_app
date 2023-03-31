import 'package:all/Models/user/user_model.dart';
import 'package:all/PL/auth/profile/profile_page.dart';
import 'package:all/PL/auth/rate_page/rate_page.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:all/start_point/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';
import 'custom_text.dart';

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =Provider.of<UserProvider>(context);
    return Drawer(

      child: ListView(
        children: <Widget>[
          drawerHeader(userInformation!),
          drawerBodyTile(Icons.home, Colors.blue, "الرئيسية",
                  () {

          }
          ),
          drawerBodyTile(Icons.settings, Colors.blue, "تحديث البيانات",  () {
            goTo(context: context,to: ProfilePage());
          }

          ),

          drawerBodyTile(Icons.star, Colors.blue, "التقييمات",  () {
            goTo(context: context,to: RatePage());
          }

          ),
          drawerBodyTile(Icons.call, Colors.blue, " للتواصل",  () async=> await launch("tel://01159245717"),),
          const Divider(
            color: primaryColor,
          ),

          drawerBodyTile(Icons.arrow_back, Colors.red, "تسجيل الخروج",
              () {

                showDialog(context: context,
                  builder: (context)
                  => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      shape:const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0))
                    ),
                      title:const Text("تنبيه"),
                      content: const Text("هل تريد تسجيل الخروج بالفعل",style: TextStyle(fontSize: 14),),
                      actions: <Widget>[
                        TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                          userProvider.logOut();

                          }, child: const Text("موافق"),),
                      ],
                    ),
                  )
                ,
                  barrierDismissible: true,

                );

            //user.signOut();
          }),
        ],
      ),
    );
  }


  drawerHeader(UserModel userModel)=>

     UserAccountsDrawerHeader(
    decoration: const BoxDecoration(color: primaryColor),
        currentAccountPicture:Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundImage: NetworkImage(userModel.imageUrl==""?appImage:userModel.imageUrl!),backgroundColor: Colors.grey,),
    ), accountEmail: CustomText(text:"الإيميل : "+userModel.email!,color: Colors.black54,alignment: Alignment.topRight,fontSize: 12,),
        accountName:  CustomText(text:"الاسم : "+userModel.userName!,color: Colors.black54,alignment: Alignment.bottomRight,fontSize: 12,),
            );



  Widget drawerBodyTile(
      IconData icon, Color color, String text, Function()? onTap) {
    return ListTile(
      title: Text(text),
      leading: Icon(
        icon,
        color: color,
      ),
      onTap: onTap,
    );
  }
}
