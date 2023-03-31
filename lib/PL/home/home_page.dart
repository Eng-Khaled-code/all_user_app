import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/PL/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'module_button.dart';

class HomePage extends StatelessWidget {
  final _key=GlobalKey<ScaffoldState>();

   HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: CustomText(text: "الرئيسية",fontWeight: FontWeight.bold,fontSize: 18,),leading: _drawerButton(),  actions: [_notiButton()],
      ),
        drawer:CustomDrawer(),
        body: SingleChildScrollView(child: Column(children:const [
          ModuleButton(name: "تسوق",imageUrl: "http://192.168.43.109/all_api/ecommerce.jpg"),
          ModuleButton(name: "عقارات",imageUrl: "http://192.168.43.109/all_api/buildings.jpg"),
          ModuleButton(name: "اطباء",imageUrl: "http://192.168.43.109/all_api/doctor.jpg"),
          ModuleButton(name: "كورسات",imageUrl: "http://192.168.43.109/all_api/courses.jpg"),
          ModuleButton(name: "بحث عن مفقود",imageUrl: "http://192.168.43.109/all_api/mps.jpg"),
          ModuleButton(name: "ثقف نفسك",imageUrl: "http://192.168.43.109/all_api/books.jpg")

        ],),));}


  Widget _drawerButton()=>Container(margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),
      child: IconButton(icon:const Icon(Icons.menu,color: primaryColor,size: 20,),onPressed:
          ()=>_key.currentState!.openDrawer()
  ));

  Widget _notiButton()=>Container(margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),
      child: IconButton(icon:const Icon(Icons.notifications,color: primaryColor,size: 20,),onPressed:
          (){}
  ));

}
