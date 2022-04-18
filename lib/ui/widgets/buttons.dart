import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

class RoundedButtonTheme extends StatelessWidget {
  final String text;
  final double width;
  final Function()? onPressed;
  final Color textColor;
  final Color? buttonColor;
  final String buttonType;
  final Widget? leading;
  final Widget? trailing;
  final double height;
  const RoundedButtonTheme(
      {required this.text,
      Key? key,
      this.width = 300,
      this.leading,
      this.trailing,
      required this.onPressed,
      this.buttonType = 'primary',
      this.textColor = kWhite,
      this.buttonColor = primaryColor,
      this.height = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        // textTheme: ButtonTextTheme.accent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text == 'Please wait'
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: kWhite,
                    ))
                : (leading ?? Container()),
            text == 'Please wait'
                ? UiSpacing.horizontalSpacingSmall()
                : const SizedBox(),
            Center(
              child: Text(text,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: buttonType == 'secondary'
                            ? primaryColor
                            : textColor,
                      )

                  //  TextStyle(
                  //   color: buttonType == 'secondary' ? primaryColor : textColor,
                  //   fontSize:
                  // ),
                  ),
            ),
            trailing != null ? UiSpacing.horizontalSpacingSmall() : Container(),
            trailing ?? Container()
          ],
        ),
        onPressed: onPressed,
      ),
      decoration: buttonType == 'secondary'
          ? BoxDecoration(
              border: Border.all(color: primaryColor, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(30.0),
              ),
              color: kWhite)
          : BoxDecoration(
              border: Border.all(
                color: primaryColor,
                width: 0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(30.0),
              ),
              color: buttonColor),
      width: width,
      height: height,
    );
  }
}
