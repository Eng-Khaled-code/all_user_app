import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class ShowBottomSheet extends StatefulWidget {
  PdfViewerController? pdfViewerController;
  String? bookName;

  ShowBottomSheet({Key?key,this.pdfViewerController,this.bookName}):super(key: key);

  @override
  _ShowBottomSheetState createState() => _ShowBottomSheetState();

}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
   List<String> myList=[];

 Future<void> _endShpref ()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.bookName!,myList);
  }
   Future<void> _startShpref ()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     List<String>? list =  prefs.getStringList(widget.bookName!)??[];
     if (list.isNotEmpty) myList = list;
     setState(() {

     });
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startShpref();

   }

   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _endShpref();
  }
  @override
  Widget build(BuildContext context) {
          return Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed:(){
                      if (myList.contains(widget.pdfViewerController!.pageNumber.toString())) {
                        Fluttertoast.showToast(
                            msg: "هذة الصفحة تم اخذها علامة مرجعية من قبل");
                      }else {
                        setState(() {
                          myList.add(widget.pdfViewerController!.pageNumber.toString());
                        });
                        Fluttertoast.showToast(msg:"تم حفظ العلامة المرجعية لصفحة لرقم ${widget.pdfViewerController!.pageNumber}");
                        _endShpref();

                      }
                    },
                    child: Text(
                      "إضافة صفحة رقم ${widget.pdfViewerController!.pageNumber} كعلامة مرجعية",
                      style: const TextStyle(
                        fontFamily: "fav",color: Colors.white
                      ),
                    ),
                  ),
                ),
                bookmarkList()
              ],

          );

  }

  Flexible bookmarkList() {
   return Flexible(

     child: ListView.builder(
       padding:const EdgeInsets.only(top:3,bottom: 3,left: 7,right: 7),
       itemBuilder: (context, position) {
         return Card(
           color: Colors.blueGrey,
           elevation: 25,
           margin: const EdgeInsets.all(3),
           child: ListTile(
             onTap: (){
               widget.pdfViewerController!.jumpToPage(int.parse(myList[position]));
               Navigator.pop(context);
             },
             title: Text(
               myList[position].toString(),
               style:
               const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
             ),
             leading:const  Icon(
               Icons.bookmark,
               color: Colors.white,
             ),
             trailing: IconButton(
                 icon:const  Icon(Icons.delete,color: Colors.black,),
                 onPressed: () {

                   Fluttertoast.showToast(msg: "تم حذف العلامة المرجعية لصفحة لرقم ${myList[position]}");
                   setState(() {
                     myList.remove(myList[position]);

                   });
                   _endShpref();
                 }),
           ),
         );
       },
       itemCount: myList.length,
     ),
   );
  }
}


