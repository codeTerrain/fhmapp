import 'package:flutter/material.dart';

import '../shared/spacing.dart';
import '../shared/style.dart';
import 'buttons.dart';
import 'misc.dart';

class ChangeInfo extends StatelessWidget {
  const ChangeInfo({
    Key? key,
    required this.header,
    required this.fields,
    required this.button,
  }) : super(key: key);

  final List<Widget> fields;
  final Widget button;
  final String header;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      width: UiSpacing.screenSize(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(color: grey, fontWeight: FontWeight.w500),
          ),
          ...fields,
          button,
        ],
      ),
      decoration: boxDecoration,
    );
  }
}

class ButtonWrapper extends StatelessWidget {
  const ButtonWrapper({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.color = primaryColor,
    this.trailing,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RoundedButtonTheme(
      width: UiSpacing.screenSize(context).width,
      height: 45,
      text: buttonText,
      isRounded: false,
      buttonColor: color,
      trailing: trailing,
      onPressed: onPressed,
    );
  }
}
