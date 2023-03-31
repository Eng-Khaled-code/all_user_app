import 'package:all/PL/widgets/constant.dart';
import 'package:all/Provider/courses_provider.dart';
import 'package:all/Provider/doctor_provider.dart';
import 'package:all/Provider/ecommerce_provider.dart';
import 'package:all/Provider/middleman_provider.dart';
import 'package:all/Provider/mps_provider.dart';
import 'package:all/Provider/read_provider.dart';
import 'package:all/Provider/user_provider.dart';
import 'package:all/start_point/screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
void main() {
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MiddlemanProvider()),
        ChangeNotifierProvider(create: (_) => EcommerceProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => MPSProvider()),
        ChangeNotifierProvider(create: (_) => ReadProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),

      ],
      child:const MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme:const AppBarTheme(
              elevation: 0.0,
              color:Colors.white ,
              centerTitle: true,
              iconTheme:  IconThemeData(color: primaryColor)
          ),
          primaryColor:primaryColor ,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "my_font" ),
      home:const Directionality(textDirection: TextDirection.rtl,child: ScreenController()) ,
    );
  }
}