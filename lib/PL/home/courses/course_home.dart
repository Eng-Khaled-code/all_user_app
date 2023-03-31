import 'package:all/PL/widgets/constant.dart';
import 'package:flutter/material.dart';

import 'package:all/PL/home/courses/course_page/course_page.dart';
import 'courses_const.dart';
class Courses extends StatefulWidget {
  const Courses({Key? key}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body:_loadingBody() ,
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }

  _loadingBody() {
    switch (coursesCurrentIndex) {
      case 0:
        return CoursesPage(page: "courses_list");
      case 1:
        return CoursesPage(page:"my_courses_list");
      case 2:
        return  CoursesPage(page: "fav_list");
      case 3:
        return  CoursesPage(page: "black_list");

    }
  }

  Widget bottomNavigationBar() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          items: const[

            BottomNavigationBarItem(

                label: 'الرئيسية',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.home))),

            BottomNavigationBarItem(
                label: 'المفضلة',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.favorite,))),
            BottomNavigationBarItem(
                label: 'القائمة السوداء',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.visibility_off,))),

            BottomNavigationBarItem(
                label:"كورساتي",
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.shopping_cart,))),
          ],
          currentIndex: coursesCurrentIndex,
          onTap: (index) {
            setState(() {
              coursesCurrentIndex = index;
            });
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black45,
          unselectedLabelStyle: const TextStyle(color: Colors.black45,fontSize: 9),
          showUnselectedLabels: true,


        ));
  }
}
