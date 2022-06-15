import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> dropItems;
  final BuildContext context;
  final String? value;
  final String hintText;
  final Widget prefixIcon;
  final Function(String?)? onChanged;
  const CustomDropDown(this.context,
      {Key? key,
      required this.dropItems,
      required this.hintText,
      required this.prefixIcon,
      this.value,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
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
            style: Theme.of(context).textTheme.bodyText2?.copyWith(height: 1.4),
          ),
        ],
      ),
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText1,
      underline: Container(
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: primaryColor)),
        ),
      ),
      onChanged: onChanged,
      items: dropItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
