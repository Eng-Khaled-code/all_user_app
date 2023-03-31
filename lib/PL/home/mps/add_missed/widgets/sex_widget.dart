import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../mps_constant.dart';

class SexWidget extends StatefulWidget {
  @override
  _SexWidgetState createState() => _SexWidgetState();
}

class _SexWidgetState extends State<SexWidget> {
  List<String> sexList=["ذكر","أنثي"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        width: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sexList.length,
            itemBuilder: (context,position){
              return InkWell(
                  onTap: (){

                    setState(()=>selectedSex=sexList[position]);},
                  child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: selectedSex==sexList[position]?primaryColor:Colors.transparent),
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                          text: sexList[position],
                          color:
                          selectedSex==sexList[position]
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
