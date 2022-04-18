import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../core/model/post_model.dart';
import '../shared/spacing.dart';
import '../shared/style.dart';
import 'misc.dart';

class Poster extends StatelessWidget {
  final Post post;

  Poster({
    Key? key,
    required this.post,
  }) : super(key: key);
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    var boxDecoration =
        BoxDecoration(color: kWhite, borderRadius: generalBorderRadius);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: boxDecoration,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            programmeTag(
              context,
              text: post.category,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: kWhite,
                  ),
            ),
            UiSpacing.horizontalSpacingTiny(),
            Text(formatTime(post.date),
                style: Theme.of(context).textTheme.bodyText2),
          ],
        ),
        UiSpacing.verticalSpacingSmall(),
        post.images != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    items: post.images?.map((image) {
                      return image;
                    }).toList(),
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      viewportFraction: 1,
                    ),
                  ),
                  Padding(
                    padding: containerPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => _carouselController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear),
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: primaryColor,
                            )),
                        IconButton(
                            onPressed: () => _carouselController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear),
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: primaryColor,
                            )),
                      ],
                    ),
                  )
                ],
              )
            : const SizedBox(),
        UiSpacing.verticalSpacingTiny(),
        post.content != null
            ? Container(
                padding: containerPadding,
                child: Text(
                  post.content!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            : const SizedBox(),
        UiSpacing.verticalSpacingSmall(),
        Container(
          padding: containerPadding,
          child: Row(
            children: [
              Image.asset('assets/images/dashboard/thumbsUp.png'),
              UiSpacing.horizontalSpacingTiny(),
              Text('2k', style: Theme.of(context).textTheme.bodyText2),
              const Spacer(),
              Image.asset('assets/images/dashboard/copy.png')
            ],
          ),
        )
      ]),
    );
  }
}
