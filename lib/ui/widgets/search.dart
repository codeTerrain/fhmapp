import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../shared/spacing.dart';
import '../shared/static_lists.dart';
import 'misc.dart';

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
          decoration:
              BoxDecoration(color: kWhite, borderRadius: generalBorderRadius),
          //BorderRadius.all(Radius.circular(10))),
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

class Searcher extends StatefulWidget {
  final String? hintText;
  final String? filter;
  final bool focus;
  const Searcher({Key? key, this.filter, this.hintText, this.focus = false})
      : super(key: key);

  @override
  State<Searcher> createState() => _SearcherState();
}

class _SearcherState extends State<Searcher> {
  TextEditingController controller = TextEditingController();
  FocusNode _focus = FocusNode();

  TextEditingController _controller = TextEditingController();
  bool foc = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FocusScope(
          child: Focus(
            onFocusChange: (focus) => foc = focus,
            child: Row(
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
                        //  focusNode: _focus,
                        decoration: InputDecoration(
                          prefixIcon:
                              widget.filter == null || widget.filter == ""
                                  ? const ImageIcon(
                                      AssetImage(
                                          'assets/images/general/search.png'),
                                      color: primaryColor,
                                      size: 50,
                                    )
                                  : InkWell(
                                      child: const Icon(
                                        Icons.clear,
                                        color: primaryColor,
                                      ),
                                      onTap: () {
                                        controller.clear();
                                      },
                                    ),
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(height: 2),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.focus
            ? SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: UiSpacing.screenSize(context).width,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 20),
                            child: Text(
                              'Filter Topic by:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: grey),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            direction: Axis.horizontal,
                            children: programChips(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox()
      ],
    );
  }

  List<Widget> programChips() {
    List<Widget> chips = [];
    for (int i = 0; i < programList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: FilterChip(
          label: Text(
            programList[i].name,
          ),
          selectedColor: primaryColor,
          showCheckmark: false,
          labelStyle:
              TextStyle(color: programList[i].isSelected ? kWhite : kBlack),
          backgroundColor: programList[i].isSelected ? primaryColor : kWhite,
          //   backgroundColor: primaryColor,
          selected: programList[i].isSelected,
          onSelected: (bool value) {
            setState(() {
              // programList[i].isSelected = value;
              // widget.model.add(programList[i].name);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
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
