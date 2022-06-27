import 'package:fhmapp/ui/shared/style.dart';
import 'package:fhmapp/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../core/model/program_model.dart';

class ProgramCard extends StatefulWidget {
  final ValueChanged<Program> onSelected;
  final Program model;
  const ProgramCard({Key? key, required this.model, required this.onSelected})
      : super(key: key);

  @override
  State<ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<ProgramCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: widget.model.isSelected ? secondary1 : Colors.transparent,
            border: Border.all(
              color: widget.model.isSelected ? primaryColor : grey,
              width: widget.model.isSelected ? 2 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.model.isSelected
                    ? const Color(0xfffbf2ef)
                    : Colors.white,
                blurRadius: 7,
                spreadRadius: 3,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Image.asset(widget.model.image),
              Text(
                widget.model.name,
              ),
            ],
          ),
        ));
  }
}

extension OnPressed on Widget {
  Widget ripple(Function() onTap,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      GestureDetector(
        child: this,
        onTap: onTap,
      );
}
