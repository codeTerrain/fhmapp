import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

import 'misc.dart';

class NeumorphDropDown extends StatelessWidget {
  final List<String> dropItems;
  final BuildContext context;
  final String? value;
  final String hintText;
  final double width;
  final Widget prefixIcon;
  final Function(String?)? onChanged;
  const NeumorphDropDown(this.context,
      {Key? key,
      required this.dropItems,
      required this.hintText,
      required this.width,
      required this.prefixIcon,
      this.value,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      //  height: widget.height,
      width: width,
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: generalBorderRadius,
          boxShadow: [
            BoxShadow(
                offset: const Offset(1, 3), color: extraGrey, blurRadius: 5)
          ]),
      child: DropdownButton<String>(
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        value: value,
        hint: Row(
          children: [
            UiSpacing.horizontalSpacingTiny(),
            prefixIcon,
            UiSpacing.horizontalSpacingSmall(),
            Text(
              hintText,
              style:
                  Theme.of(context).textTheme.bodyText2?.copyWith(height: 1.4),
            ),
          ],
        ),
        iconSize: 24,
        elevation: 16,
        style: Theme.of(context).textTheme.bodyText1,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: dropItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
