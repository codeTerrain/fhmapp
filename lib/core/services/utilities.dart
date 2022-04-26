import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:flutter/material.dart';

import '../../ui/shared/style.dart';
import '../../ui/widgets/buttons.dart';
import '../../ui/widgets/misc.dart';

class Utilities {
  static tAndC(BuildContext context,
      {String title = '', String description = 'Task Updated Successfully'}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: roundedListTileBorder,
          title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: primaryColor, width: 3),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.close,
                    color: primaryColor,
                    size: 15,
                  )),
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.  ',
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            Center(
              heightFactor: 2,
              child: RoundedButtonTheme(
                  width: 100,
                  text: 'Agree',
                  buttonColor: kBlack,
                  onPressed: () => Navigator.pop(context)),
            ),
          ],
        );
      },
    );
  }

  static activityDone(BuildContext context,
      {String title = '', String description = 'Success'}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        var failure = const CircleAvatar(
          backgroundColor: secondary2,
          child: Icon(Icons.highlight_remove_rounded),
        );
        var success = const CircleAvatar(
          backgroundColor: primaryColor,
          child: Icon(Icons.check),
        );
        return AlertDialog(
          shape: roundedListTileBorder,
          title: Row(
            children: [
              description == 'Success' ? success : failure,
              UiSpacing.horizontalSpacingTiny(),
              Text(
                description,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: 15,
                    color:
                        description == 'Success' ? primaryColor : secondary2),
              )
            ],
          ),
          // actions: <Widget>[
          //   Center(
          //     heightFactor: 2,
          //     child: RoundedButtonTheme(
          //         width: 100,
          //         text: 'Done',
          //         buttonColor: kBlack,
          //         onPressed: () => Navigator.pop(context)),
          //   ),
          // ],
        );
      },
    );
  }
}
