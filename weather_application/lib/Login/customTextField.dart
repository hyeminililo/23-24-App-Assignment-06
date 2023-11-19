import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    required this.onChanged,
    this.validator,
    this.controller,
  });
  @override
  Widget build(BuildContext context) {
    const baseborder = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.lightGreenAccent,
      width: 1.0,
    ));

    return TextFormField(
        cursorColor: Colors.pinkAccent,
        controller: controller,
        autofocus: autoFocus,

        // 값이 바뀔 때마다 실행됨
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            errorText: errorText,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 14.0,
            ),
            fillColor: Colors.grey,
            filled: false,

            // 입력시 기본 상태
            border: baseborder,

            // 선택되지 않았을 때 상태
            enabledBorder: baseborder,

            // 선택되었을 때 상태
            focusedBorder: baseborder.copyWith(
              borderSide: baseborder.borderSide.copyWith(
                color: Colors.amberAccent,
              ),
            )));
  }
}
