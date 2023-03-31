import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../mps_constant.dart';

class MissedImage extends StatefulWidget {
  const MissedImage({Key? key}) : super(key: key);

  _MissedImageState createState() => _MissedImageState();
}

class _MissedImageState extends State<MissedImage> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          child:   imageFile !=null
                  ? InkWell(
                      onTap: onTap,
                      child:
                          Image.file(File(imageFile!.path), fit: BoxFit.cover))
                  : imageFile == null && (imagePath == ""||imagePath==null)
                      ? Padding(
                          padding:const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: onTap,
                            child: Icon(Icons.add_a_photo,
                                size: 80, color: Colors.grey.withOpacity(.5)),
                          ))
                      : InkWell(
                          onTap: onTap,
                          child: Image.network(
                            imagePath!,
                            fit: BoxFit.fill,
                          ))),
    );
  }

  onTap() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
  }

  @override
  void dispose() {

   imageFile=null;
   imagePath="";

    super.dispose();
  }

}
