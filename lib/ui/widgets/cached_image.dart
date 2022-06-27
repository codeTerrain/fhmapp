import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../shared/spacing.dart';
import '../shared/style.dart';
import 'misc.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key? key,
    required this.image,
    this.fit = BoxFit.fitWidth,
    this.margin = const EdgeInsets.symmetric(horizontal: 12),
  }) : super(key: key);

  final String? image;
  final BoxFit? fit;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: UiSpacing.screenSize(context).width,
      height: 200,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        child: (image != null)
            ? Container(
                margin: margin,
                child: ClipRRect(
                  borderRadius: generalBorderRadius,
                  child: CachedNetworkImage(
                    imageUrl: image!,
                    fit: fit,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            linearProgressIndicator(downloadProgress),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 500),
                  ),
                ))
            : Image.asset(
                'assets/images/general/placeholder.png',
                fit: BoxFit.fill,
                color: transGrey,
              ),
      ),
    );
  }
}
