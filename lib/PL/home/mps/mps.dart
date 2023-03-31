import 'package:all/PL/widgets/constant.dart';
import 'package:flutter/material.dart';

import 'add_missed/add_missed.dart';
import 'finish_found/finish_found_page.dart';
import 'missed/missed_page.dart';
import 'mps_constant.dart';

class MPS extends StatefulWidget {
  @override
  _MPSState createState() => _MPSState();
}

class _MPSState extends State<MPS> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body:_loadingBody() ,
        bottomNavigationBar: bottomNavigationBar(),
        floatingActionButton: _floatingButton(),
      ),
    );
  }


  _loadingBody() {
    switch (currentIndex) {
      case 0:
        return MissedPage();
      case 1:
        return MissedPage();
      case 2:
        return const FinishFoundPage();
      case 3:
        return const FinishFoundPage();

    }
  }



  Widget bottomNavigationBar() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          items: const[

            BottomNavigationBarItem(

                label: 'تبليغ فقد',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.person_search))),
            BottomNavigationBarItem(
                label: 'تبليغ إيجاد',
                icon: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(Icons.person_search))),
            BottomNavigationBarItem(
                label:"نتائج تبليغات الفقد",
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.assignment_turned_in,))),
            BottomNavigationBarItem(
                label: 'نتائج تبليغات الإيجاد',
                icon: Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Icon(Icons.assignment_turned_in,))),
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

  _floatingButton() {
    return currentIndex==0||currentIndex==1?FloatingActionButton.extended(onPressed: (){
      selectedEyeColor="اختر واحدة";
      selectedHairColor="اختر واحدة";
      selectedFaceColor="اختر واحدة";

      goTo(context: context, to:AddMissed(addOrUpdate: "إضافة",missedStatus: "انتظار",messedOrFound:currentIndex==0? "فقد":"إيجاد"));
    }, label:Text( currentIndex==0?"تبليغ عن مفقود":"تبليغ عن إيجاد")):Container();
  }

}
