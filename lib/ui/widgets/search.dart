import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

Widget search(
  BuildContext context, {
  String? hintText,
  String? filter,
  TextEditingController? controller,
}) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(
          //  padding: const EdgeInsets.only(left: 10),
          height: 50,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: filter == null || filter == ""
                    ? const ImageIcon(
                        AssetImage('assets/images/general/search.png'),
                        color: primaryColor,
                        size: 50,
                      )
                    : InkWell(
                        child: const Icon(
                          Icons.clear,
                          color: primaryColor,
                        ),
                        onTap: () {
                          controller?.clear();
                        },
                      ),
                border: InputBorder.none,
                hintText: hintText,
                hintStyle:
                    Theme.of(context).textTheme.bodyText2?.copyWith(height: 2),
              )),
        ),
      ),
    ],
  );
}

// extension OnPressed on Widget {
//   Widget ripple(Function onPressed,
//           {BorderRadiusGeometry borderRadius =
//               const BorderRadius.all(Radius.circular(5))}) =>
//       Stack(
//         children: <Widget>[
//           this,
//           Positioned(
//             left: 0,
//             right: 0,
//             top: 0,
//             bottom: 0,
//             child: FlatButton(
//                 shape: RoundedRectangleBorder(borderRadius: borderRadius),
//                 onPressed: () {
//                   if (onPressed != null) {
//                     onPressed();
//                   }
//                 },
//                 child: Container()),
//           )
//         ],
//       );
// }
