import 'package:flutter/material.dart';
import 'package:fhmapp/ui/shared/style.dart';

import 'misc.dart';

class NeumorphTextField extends StatefulWidget {
  final String hintText;
  final bool enabled;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Color color;
  final FormFieldSetter<String>? onsaved;
  final FormFieldSetter<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool isNeumorphic;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final double height;
  final double width;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const NeumorphTextField(
      {this.hintText = '',
      Key? key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.onsaved,
      this.maxLength,
      this.isNeumorphic = true,
      this.obscureText = false,
      this.onChanged,
      this.enabled = true,
      this.color = kWhite,
      this.height = 50,
      this.width = 300,
      this.maxLines,
      this.minLines,
      this.prefixIcon,
      this.suffixIcon,
      this.validator})
      : super(key: key);

  @override
  _NeumorphTextFieldState createState() => _NeumorphTextFieldState();
}

class _NeumorphTextFieldState extends State<NeumorphTextField> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: generalBorderRadius,
          boxShadow: widget.isNeumorphic
              ? [
                  BoxShadow(
                      offset: const Offset(1, 3),
                      color: extraGrey,
                      blurRadius: 5)
                ]
              : null),
      child: TextFormField(
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines ?? 1,
        minLines: widget.minLines,
        autofocus: false,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: widget.obscureText ? _obscureText : false,
        onSaved: widget.onsaved,
        validator: widget.validator,
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(height: 1.4),
            border: InputBorder.none,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: () {
                      _toggle();
                    },
                    icon: Icon(
                        _obscureText == true
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _obscureText == true ? primaryColor : grey),
                  )
                : widget.suffixIcon),
      ),
    );
  }
}
