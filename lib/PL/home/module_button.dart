import 'package:all/PL/home/read_books/read_page.dart';
import 'package:all/PL/widgets/constant.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:all/Provider/read_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'courses/course_home.dart';
import 'doctor/doctor.dart';
import 'ecommerce/ecommerce.dart';
import 'middleman/middleman_page.dart';
import 'mps/mps.dart';
import 'read_books/book/book_page.dart';

class ModuleButton extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final String? bookUrl;
  final int? isFav;
  final int? isBlack;
  final int? likeCount;
  final int? bookId;



  const ModuleButton({Key? key, this.name,this.bookId,this.imageUrl,this.bookUrl="",this.likeCount=0,this.isBlack=0,this.isFav=0}) : super(key: key);

  @override
  State<ModuleButton> createState() => _ModuleButtonState();
}

class _ModuleButtonState extends State<ModuleButton> with SingleTickerProviderStateMixin {

  AnimationController? _controller;
  @override
  void initState() {


    _controller = AnimationController(
      vsync: this,
      duration:const Duration(
          milliseconds: 500
      ),
      lowerBound: 0,
      upperBound:1000 ,
    )..addListener(() {
      setState(() {
      });
    });

    _controller!.forward();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child:Column(
        children: [
          widget.bookUrl==""?Container(): _bookTopRow(),
          InkWell(
            onTap: () {
              if(widget.bookUrl!=""){
                goTo(context: context, to: MyPDFScreen(bookName: widget.name,bookUrl: widget.bookUrl,));
                return;
              }

              if(widget.name=="عقارات")
              {
                goTo(context: context,to: const Middleman());
              }
              else if(widget.name=="تسوق")
              {
                goTo(context: context,to:const Ecommerce());

              }
              else if(widget.name=="اطباء"){
                goTo(context: context,to:Doctor() );
              }
              else if(widget.name=="بحث عن مفقود"){
                goTo(context: context,to:MPS() );
              }
              else if(widget.name=="ثقف نفسك"){
                goTo(context: context,to:BookListPage() );
              }
              else if(widget.name=="كورسات"){
                goTo(context: context,to:const Courses() );
              }
            },
            splashColor: Colors.blue.withOpacity(0.5),
            child: Ink(
              width:_controller!.value,
              height: 170,
              decoration: BoxDecoration(border: Border.all(color: primaryColor),borderRadius: BorderRadius.circular(15),image:
              DecorationImage(image: NetworkImage(widget.imageUrl!), fit: BoxFit.cover,onError: (k,l)=>Image.asset(
                "assets/images/errorimage.png",
                fit: BoxFit.fill,
              ),),
              ),
            child: widget.bookUrl==""?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.name!,style: TextStyle(color:widget.name=="بحث عن مفقود"?Colors.blue: Colors.black,fontWeight:FontWeight.bold ),),
            ):Container(),
          ),),
        ],
      )
      );
  }

  _bookTopRow() {
    ReadProvider readProvider =Provider.of<ReadProvider>(context,listen: false);
  int _length=widget.name!.length;
  return widget.bookUrl==""?Container():Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(text:widget.name!.substring(0,_length>30?30:_length),color:Colors.black,fontWeight:FontWeight.bold ,maxLine: 1),
      ),
      Row(
        children: [
          _likeWidget(readProvider),
          _blackListWidget(readProvider)

        ],
      ),
      ],
    );
  }

  Widget _likeWidget(ReadProvider readProvider) {
    Color color=widget.isFav==1?Colors.pink:Colors.grey;
    return
      readProvider.isFavLoading?const SizedBox(width: 20,height: 20,child: CircularProgressIndicator(strokeWidth: .7,),)
        :
      widget.isBlack==1?Container():
    TextButton(child: Row(
    children: [
    CustomText(text:"${widget.likeCount}  ".toString(),color:color),
    Icon(Icons.favorite,color:color),

    ],
    ),onPressed: ()async{
    await readProvider.favourateOperations(postId:widget.bookId.toString(),type:widget.isFav==1?"dislike":"like" );
    },);
  }

  _blackListWidget(ReadProvider readProvider) {
    return widget.isFav==0?IconButton(onPressed: ()=>showDialogFor(
    context:context,
    contentText: widget.isBlack==0?"هل تريد الوضع في القائمة السوداء":"هل تريد الإزالة من القائمة السوداء",
    title: "تأكيد",
    onPress: ()async{
    Navigator.pop(context);
    await readProvider.favourateOperations(postId:widget.bookId.toString(),type: widget.isBlack==0?"black":"unblack");
    }),icon: Icon(widget.isBlack==0?Icons.visibility_off:Icons.visibility)):Container();
  }
}