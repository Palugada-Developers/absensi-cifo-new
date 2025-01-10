import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/themes/app.themes.dart';

class WidgetsForm extends StatefulWidget {
  const WidgetsForm(
      {super.key,
        required this.controller,
        required this.label,
        required this.hint,
        required this.helper,
        required this.isObscure,
        required this.minLines});

  final RxString controller;
  final String label;
  final String hint;
  final String helper;
  final bool isObscure;
  final int minLines;

  @override
  State<WidgetsForm> createState() => _WidgetsFormState();
}

class _WidgetsFormState extends State<WidgetsForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextField(
            onChanged: (value) {
              widget.controller.value = value;
            },
            minLines: widget.minLines,
            maxLines: widget.isObscure ? 1 : 5,
            obscureText: widget.isObscure,
            cursorColor: AppThemes.blackColor,
            style: GoogleFonts.poppins(
              color: AppThemes.blackColor,
              fontSize: 60.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              fillColor: Colors.grey,
              label: Text(widget.label),
              labelStyle: GoogleFonts.poppins(
                color: AppThemes.blackColor,
                fontSize: 60.sp,
                fontWeight: FontWeight.w500,
              ),
              hintText: widget.hint,
              hintStyle: GoogleFonts.poppins(
                color: AppThemes.blackColor.withAlpha(100),
                fontSize: 50.sp,
                fontWeight: FontWeight.w300,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: AppThemes.blackColor.withAlpha(100),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: AppThemes.blackColor.withAlpha(50),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: AppThemes.blackColor.withAlpha(100),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 0.01.sh),
        Text(
          widget.helper,
          style: GoogleFonts.poppins(
            color: AppThemes.blackColor.withAlpha(200),
            fontSize: 50.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
