
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/common/constants/app_colours.dart';

import '../constants/app_images.dart';
import '../constants/app_strings.dart';
class CustomDropDown extends StatefulWidget {
  late String dropdownValue;
  late List<String> dropdownList;
  Function onChangedClick;
  String errorText;

  CustomDropDown({
    Key? key,
    required this.dropdownValue,
    required this.dropdownList,
    required this.onChangedClick,
    this.errorText = " ",
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
// <<<<<<< HEAD
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: AppColors.COLOR_TEXT_FEILD_BORDER,
                width: 1,
// =======
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           border: Border.all(
//             color: AppColors.COLOR_TEXT_FEILD_BORDER,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: DropdownButton<String>(
//           value: widget.dropdownValue,
//           hint: Text(widget.dropdownValue),
//           isExpanded: true,
//           iconEnabledColor: Colors.black,
//           style: const TextStyle(color: Colors.white),
//           underline: const SizedBox(),
//           dropdownColor: Colors.white,
//           onChanged: (String? newValue) {
//             widget.onChangedClick(newValue);
//           },
//           items: widget.dropdownList.map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(value,
//                     style: const TextStyle(color: Colors.black)),
// >>>>>>> 4c738f9533670f228d39d2a3db18aef46ecfaf66
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton<String>(
              value: widget.dropdownValue,
              isExpanded: true,
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              dropdownColor: AppColors.textColorGrey,
              onChanged: (String? newValue) {
                widget.onChangedClick(newValue);
              },
              items: widget.dropdownList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value,
                        style: const TextStyle(color: Colors.black)),
                  ),
                );
              }).toList(),
            ),
          ),
          Visibility(
            visible: null != widget.errorText && widget.errorText.length > 0,
            child: Text(widget.errorText,
                style: const TextStyle(color: Colors.red, fontSize: 10.0)),
          )
        ],
      ),
    );
  }
}