import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'booking/booking_page.dart';
import 'doctor_constant.dart';
import 'doctors_page/doctors_page.dart';
class Doctor extends StatefulWidget {
  @override
  _DoctorState createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body:_loadingBody() ,
        bottomNavigationBar: bottomNavigationBar(),
      ),
    );
  }


  _loadingBody() {
    switch (currentIndex) {
      case 0:
        return DoctorsPage();
      case 1:
        return BookingPage();

    }
  }



  Widget bottomNavigationBar() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          items: const[

            BottomNavigationBarItem(

                label: 'الدكتور',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.person))),
            BottomNavigationBarItem(
                label: 'حجوزاتي',
                icon: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(Icons.library_books))),

          ],
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black45,
          unselectedLabelStyle: const TextStyle(color: Colors.black45,fontSize: 9),
          showUnselectedLabels: true,


        ));
  }

}
