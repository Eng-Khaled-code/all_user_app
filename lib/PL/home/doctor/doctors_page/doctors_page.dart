import 'package:all/PL/home/ecommerce/ecommerce_constants.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/Provider/doctor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'doctor_card.dart';
class DoctorsPage extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DoctorProvider doctorProvider=Provider.of<DoctorProvider>(context);

    return  SafeArea(
        child:  Column(children: [
            _buildSearchTextfieldWidget(doctorProvider),
            _dataWidget(doctorProvider),
          ],),

      );}

  _dataWidget(DoctorProvider doctorProvider){
    return Expanded(
        child:RefreshIndicator(
        onRefresh: ()async{
      await doctorProvider.loadDoctorsData("in");

    },
    child:doctorProvider.isLoading
        ?
    loadingWidget2()
        :
    doctorProvider.doctorsList.isEmpty
        ?
    noDataCard(text: "لا توجد إقتراحات لدكاترة",icon: Icons.person)
        :
     SizedBox(
        child:
        ListView.builder(
            itemCount:doctorProvider.doctorsList.length,
            itemBuilder: (context,position){
              return
              DoctorCard(model:doctorProvider.doctorsList[position],doctorProvider: doctorProvider);
            }

        ),
      ),
    ));
  }


  Widget _buildSearchTextfieldWidget(DoctorProvider doctorProvider) {
    return Container(
      margin:const EdgeInsets.all( 10),
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border.all(color:Colors.grey),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        onChanged: (value) {
          doctorProvider.loadAndSearch(searchValue: value);
        },
        style:const TextStyle(color: Colors.grey, fontSize: 14),
        controller: searchController,
        decoration:const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: " بحث  بالتخصص ...",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            )),
      ),
    );
  }
}