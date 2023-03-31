
import 'package:all/PL/home/read_books/book/show_bottom_sheet.dart';
import 'package:all/PL/widgets/custom_text.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class MyPDFScreen extends StatefulWidget {

final String? bookUrl;
final String? bookName;


const MyPDFScreen({Key? key,this.bookUrl,this.bookName}):super(key: key);

@override
  _MyPDFScreenState createState() => _MyPDFScreenState();
}

class _MyPDFScreenState extends State<MyPDFScreen> {
  IconData playPauseIcon = Icons.play_circle_outline;
  TextEditingController? _txtSearchController;
  PdfViewerController? _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _txtSearchController = TextEditingController();
    assetsAudioPlayer.open(
      Audio("assets/music/music.mp3"),loopMode: LoopMode.playlist,autoStart: false
    );
    _startShprefPage();

    super.initState();
  }

  @override
  void dispose() {
    _endShpref();
    _txtSearchController!.dispose();
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  _endShpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setInt('currentPage',_pdfViewerController!.pageNumber );
  }

  _startShprefPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _pdfViewerController!.jumpToPage( prefs.getInt('currentPage')??1);

  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar:_myAppBar() ,
        backgroundColor: Colors.white,
        body: SfPdfViewer.network(
          widget.bookUrl!,
          controller: _pdfViewerController,
          key: _pdfViewerKey,
          onTextSelectionChanged:
              (PdfTextSelectionChangedDetails details) {
            if (details.selectedText == null && _overlayEntry != null) {
              _overlayEntry!.remove();
              _overlayEntry = null;
            } else if (details.selectedText != null && _overlayEntry == null) {
              _showContextMenu(context, details);
            }
          },
        ),
      ),
    );
  }
  AppBar _myAppBar(){
  return AppBar(
    centerTitle: false,
    title:  _appBarTitle(),
leading: _bookContentWidget(),
    actions: <Widget>[
      _playPauseButton(),
      _bookMarkButton(),
      _screenRotateButton(),
      _searchButton(),
    ],
  );

  }
  CustomText _appBarTitle() {
    return CustomText(
      text:widget.bookName!,
      fontSize: 12,
      maxLine: 1,
      fontWeight: FontWeight.bold,alignment: Alignment.centerRight,
    );
  }

  IconButton _bookContentWidget() {
    return IconButton(
      icon:const Icon(Icons.menu),
      onPressed: () {
        _pdfViewerKey.currentState?.openBookmarkView();
      },
      tooltip: "محتويات الكتاب",
    );
  }

  void _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ShowBottomSheet(pdfViewerController: _pdfViewerController,bookName: widget.bookName,);
        });
  }

  void  _showSearchDialog(BuildContext context) {
    var alertSearch = AlertDialog(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title:  CustomText(
        text:"بحث برقم الصفحة",
       alignment: Alignment.centerRight,
      ),
      content: TextField(
        keyboardType: TextInputType.number,
        controller: _txtSearchController,
        decoration: InputDecoration(hintText: "ادخل رقم الصفحة",hintStyle:const TextStyle(color: Colors.blue,fontSize: 12),counterText:_pdfViewerController!.pageCount.toString()+" - 1" ),

      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {

           if(_txtSearchController!.text!=""){
             _pdfViewerController!.jumpToPage(int.tryParse(_txtSearchController!.text)!);
             Navigator.pop(context);
              }
            else{
            Fluttertoast.showToast(msg:"يجب ان تدخل رقم الصفحة");
            }

          },
          child:const Text("بحث"),
        ),
        TextButton(
          onPressed: ()=>Navigator.pop(context),
          child:const Text("إلغاء"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
            textDirection: TextDirection.rtl, child: alertSearch);
      },
    );
  }

  OverlayEntry? _overlayEntry;
  void _showContextMenu(BuildContext context,PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child:
        RaisedButton(child:const Text('نسخ',style: TextStyle(fontSize: 17)),onPressed: (){
          Clipboard.setData(ClipboardData(text: details.selectedText));
          _pdfViewerController!.clearSelection();
        },color: Colors.white,elevation: 10,),
      ),
    );
    _overlayState.insert(_overlayEntry!);
  }

  IconButton _playPauseButton() {
    return       IconButton(
      icon: Icon(playPauseIcon),
      onPressed: () {
        setState(() {
          if (playPauseIcon == Icons.play_circle_outline) {
            playPauseIcon = Icons.pause_circle_outline;
            assetsAudioPlayer.play();
          }else {
            playPauseIcon = Icons.play_circle_outline;
            assetsAudioPlayer.pause();
          }});
      },
      tooltip: "مشغل الموسيقي",
    );

  }

  IconButton _bookMarkButton() {
    return IconButton(
      icon: const Icon(Icons.bookmark),
      onPressed: () {
         _bottomSheet();
      },
      tooltip: "العلامات المرجعية",
    );
  }

  IconButton _searchButton() {
    return IconButton(
      icon:const Icon(Icons.search),
      onPressed: () {
        _showSearchDialog(context);
      },
      tooltip: "بحث",
    );
  }

  IconButton _screenRotateButton() {
    return IconButton(
      icon: const Icon(Icons.screen_lock_rotation),
      onPressed: () {
        if (MediaQuery.of(context).orientation == Orientation.portrait){
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeLeft]);}
        else{
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp]);
        }},
      tooltip: "تدوير الشاشة",
    );
  }


}