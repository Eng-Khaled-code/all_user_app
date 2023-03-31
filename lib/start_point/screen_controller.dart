import 'package:all/PL/auth/log_in.dart';
import 'package:all/PL/auth/register.dart';
import 'package:all/PL/home/home_page.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ScreenController extends StatelessWidget {
  const ScreenController({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    UserProvider userProvider=Provider.of<UserProvider>(context);


    return
      userProvider.page=="home"
          ?
      HomePage()
          :
      userProvider.page=="register"
          ?
      RegisterPage()
          :
    LogIn();

  }


}