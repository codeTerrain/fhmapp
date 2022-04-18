import 'package:flutter/material.dart';
import 'package:fhmapp/ui/shared/style.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool enabled;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Color color;
  final Function(String?)? onsaved;
  final Function(String)? onChanged;
  final String? Function(String?)? validation;
  final int? maxLines;
  final double height;
  final double width;
  final Widget? prefixIcon;
  const CustomTextField(
      {this.hintText = '',
      Key? key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.onsaved,
      this.onChanged,
      this.enabled = true,
      this.color = kWhite,
      this.height = 40,
      this.width = 300,
      this.maxLines,
      this.prefixIcon,
      this.validation})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        onChanged: widget.onChanged,
        maxLines: widget.maxLines ?? 1,
        autofocus: false,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: (widget.hintText == "Password" ||
                widget.hintText == "Create New Password" ||
                widget.hintText == "Re-type your Password" ||
                widget.hintText == "Re-type New Password")
            ? _obscureText
            : false,
        onSaved: widget.onsaved,
        validator: widget.validation,
        decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(height: 1.4),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: secondary1, width: 2.0),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: (widget.hintText == "Password" ||
                    widget.hintText == "Create New Password" ||
                    widget.hintText == "Re-type your Password" ||
                    widget.hintText == "Re-type New Password")
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
                : null),
      ),
    );
  }
}
