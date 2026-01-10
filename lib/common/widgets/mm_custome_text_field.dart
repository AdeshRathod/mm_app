import 'package:flutter/material.dart';
import 'package:app/common/constants/app_colours.dart';

class MmCustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? errorText;
  final Function? onTap;
  final TextCapitalization? textCapitalization;
  final double fontSize;
  final bool readOnly;
  final Function(String)? onChanged;

  const MmCustomTextField(
    this.hint,
    this.controller, {
    super.key,
    this.isPassword = false,
    this.errorText,
    this.onTap,
    this.keyboardType,
    this.textCapitalization,
    this.fontSize = 14.0, // Default font size
    this.readOnly = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal:
              0.0), // Remove default horizontal padding to let parent control it
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.text,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            style: TextStyle(color: Colors.black, fontSize: fontSize),
            textAlign: TextAlign.left,
            obscureText: isPassword,
            readOnly: readOnly,
            onTap: onTap != null ? () => onTap!() : null,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: hint,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                borderSide: const BorderSide(
                  color: AppColors.COLOR_TEXT_FEILD_BORDER,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.COLOR_TEXT_FEILD_BORDER,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.red, // Standard error color
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: AppColors.COLOR_TEXT_FEILD_BORDER,
                  width: 1.0,
                ),
              ),
            ),
          ),
          if (errorText != null && errorText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, left: 0.0), // Start (left) alignment
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
        ],
      ),
    );
  }
}
