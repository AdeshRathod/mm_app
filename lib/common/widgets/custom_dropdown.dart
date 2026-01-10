import 'package:flutter/material.dart';
import 'package:app/common/constants/app_colours.dart';

class CustomDropDown extends StatefulWidget {
  final String dropdownValue;
  final List<String> dropdownList;
  final Function onChangedClick;
  final String? errorText;

  const CustomDropDown({
    Key? key,
    required this.dropdownValue,
    required this.dropdownList,
    required this.onChangedClick,
    this.errorText,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.COLOR_TEXT_FEILD_BORDER,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.COLOR_TEXT_FEILD_BORDER,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.0,
                ),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.dropdownList.contains(widget.dropdownValue)
                    ? widget.dropdownValue
                    : widget.dropdownList
                        .first, // Fallback if value not in list, though logic should prevent this
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    widget.onChangedClick(newValue);
                  }
                },
                items: widget.dropdownList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return widget.dropdownList.map<Widget>((String item) {
                    return Text(
                      item,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
                    );
                  }).toList();
                },
              ),
            ),
          ),
          if (widget.errorText != null && widget.errorText!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 0.0),
              child: Text(
                widget.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
        ],
      ),
    );
  }
}
