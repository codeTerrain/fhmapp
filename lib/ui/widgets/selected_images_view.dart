import 'dart:io';

import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/misc.dart';
import 'package:flutter/material.dart';

class SelectedImages extends StatelessWidget {
  final List<File> imageFiles;

  const SelectedImages({
    Key? key,
    required this.imageFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        separatorBuilder: ((context, index) =>
            UiSpacing.horizontalSpacingTiny()),
        physics: scrollPhysics,
        itemCount: imageFiles.length,
        itemBuilder: ((context, index) => ClipRRect(
              borderRadius: generalBorderRadius,
              child: Image.file(imageFiles[index]),
            )),
        scrollDirection: Axis.horizontal,
        padding: mainPadding,
      );

  // GridView.count(
  //       physics: const BouncingScrollPhysics(),
  //       padding: const EdgeInsets.all(12),
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 12,
  //       mainAxisSpacing: 12,
  //       children: imageFiles
  //           .map((imageFile) => ClipRRect(
  //                 borderRadius: BorderRadius.circular(16),
  //                 child: Image.file(imageFile),
  //               ))
  //           .toList(),
  //     );
}
