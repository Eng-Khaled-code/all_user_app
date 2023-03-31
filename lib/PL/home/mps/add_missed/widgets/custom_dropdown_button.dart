import 'package:all/PL/home/mps/mps_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String>? items;
  final String? lable;
  const CustomDropdownButton({Key? key, this.items, this.lable}) : super(key: key);

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lable!,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          DropdownButton<String>(
            items: widget.items!
                .map((item) => DropdownMenuItem(
                      child:
                          Text(item, style: TextStyle(fontSize: width * 0.033)),
                      value: item,
                    ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                widget.lable == "لون البشرة"
                    ? selectedFaceColor = value!
                    : widget.lable == "لون العين"
                        ? selectedEyeColor = value!
                        :selectedHairColor = value!;
              });
            },
            value: widget.lable == "لون البشرة"
                ? selectedFaceColor
                : widget.lable == "لون العين"
                    ? selectedEyeColor
                    : selectedHairColor,
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
