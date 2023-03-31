import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'booking_card.dart';
class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedType="الانتظار";
  List<String> types=["الانتظار","المقبول","المرفوض","الملغي","تم الكشف"];
  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider=Provider.of<DoctorProvider>(context);

    return  SafeArea(
        child: Column(children: [
            _typesWidget(),
            _dataWidget(doctorProvider),
          ],),

      );}

  _dataWidget(DoctorProvider doctorProvider){
    int itemCount=
    selectedType=="الانتظار"
        ?
    doctorProvider.waitingBookingList.length
        :
    selectedType=="المقبول"
        ?
    doctorProvider.acceptedBookingList.length
        :
    selectedType=="المرفوض"
        ?
    doctorProvider.refusedBookingList.length
        :
    selectedType=="الملغي"
        ?
    doctorProvider.canceledBookingList.length
        :
    selectedType=="تم الكشف"
        ?
    doctorProvider.finishedBookingList.length
        : 0;

    return Expanded(
        child: RefreshIndicator(
        onRefresh: ()async{
      await doctorProvider.loadDoctorsData("in");
    },
    child: doctorProvider.isLoading
        ?
    loadingWidget2()
        :
    selectedType=="الانتظار"&&doctorProvider.waitingBookingList.isEmpty ? noDataCard(text: "لا توجد حجوزات في قائمة الانتظار",icon: Icons.library_books)
    :
    selectedType=="المقبول"&&doctorProvider.acceptedBookingList.isEmpty ? noDataCard(text: "لا توجد حجوزات مقبولة",icon: Icons.library_books)
        :
    selectedType=="المرفوض"&&doctorProvider.refusedBookingList.isEmpty ? noDataCard(text: "لا توجد حجوزات مرفوضه",icon: Icons.library_books)
        :
    selectedType=="الملغي"&&doctorProvider.canceledBookingList.isEmpty ? noDataCard(text: "لا توجد حجوزات ملغية",icon: Icons.library_books)
        :
    selectedType=="تم الكشف"&&doctorProvider.finishedBookingList.isEmpty ? noDataCard(text: "لا توجد حجوزات تمالكشف عليها بالفعل",icon: Icons.library_books)

        :
    SizedBox(
        child:
        ListView.builder(
            itemCount:itemCount,
            itemBuilder: (context,position){
              switch(selectedType)
              {
                case "الانتظار":
                  return  BookingCard(model:doctorProvider.waitingBookingList[position],doctorProvider:doctorProvider);
                case "المقبول":
                  return  BookingCard(model:doctorProvider.acceptedBookingList[position],doctorProvider:doctorProvider);
                case "تم الكشف":
                  return  BookingCard(model:doctorProvider.finishedBookingList[position],doctorProvider:doctorProvider);
                case "المرفوض":
                  return BookingCard(model:doctorProvider.refusedBookingList[position],doctorProvider:doctorProvider);
                case "الملغي":
                  return BookingCard(model:doctorProvider.canceledBookingList[position],doctorProvider:doctorProvider);
                default:
                  return Container();
              } }

        ),
      ),
    ));
  }

  _typesWidget() {

  return SizedBox(
     height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: types.length,
          itemBuilder: (context,position){
          return InkWell(
            onTap: ()=>setState(()=>selectedType=types[position]),
            child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: selectedType==types[position]?primaryColor:Colors.transparent),
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                    text: types[position],
                  color:
                  selectedType==types[position]
                      ?
                  Colors.white
                      :
                  primaryColorDark
                )
            ));

      }),
    );

  }
}