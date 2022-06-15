import 'package:carousel_slider/carousel_slider.dart';
import 'package:fhmapp/core/services/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/post_model.dart';
import '../shared/spacing.dart';
import '../shared/style.dart';
import '../viewmodels/login_view_model.dart';
import '../viewmodels/profile_view_model.dart';
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
            programmeTag(context,
                text: post.category,
                style: Theme.of(context).textTheme.headline4),
            //   UiSpacing.horizontalSpacingTiny(),
            Text(
              formatTime(post.date),
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    color: transGrey,
                  ),
            ),
          ],
        ),
        UiSpacing.verticalSpacingSmall(),
        post.images != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CarouselSlider(
                    items: post.images?.map((image) {
                      return Image.asset(image, fit: BoxFit.fitWidth);
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
        Container(padding: containerPadding, child: ActionRow(post: post))
      ]),
    );
  }
}

class ActionRow extends StatefulWidget {
  final Post post;
  const ActionRow({Key? key, required this.post}) : super(key: key);

  @override
  State<ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<ActionRow> {
  Color likeColor = primaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) => model.getUserInfo(),
      builder: (context, model, child) {
        return Row(
          children: [
            like(context, model),
            UiSpacing.horizontalSpacingTiny(),
            Text(widget.post.likes.length.toString(),
                style: Theme.of(context).textTheme.bodyText2),
            const Spacer(),
            widget.post.content != null ? copy(context) : const SizedBox()
          ],
        );
      },
    );
  }

  IconButton copy(BuildContext context) {
    return IconButton(
        onPressed: () => Clipboard.setData(ClipboardData(
              text: widget.post.content,
            )).then((_) => Utilities.showSnackBar(context,
                width: 110, text: 'Text copied!')),
        icon: const ImageIcon(
          AssetImage('assets/images/dashboard/copy.png'),
          color: primaryColor,
        ));
  }

  IconButton like(BuildContext context, ProfileViewModel model) {
    return IconButton(
        onPressed: () => setState(() {
              widget.post.likes.contains('PedHu77dM0fVk1sGzniCZifIEHf1')
                  ? widget.post.likes.remove('PedHu77dM0fVk1sGzniCZifIEHf1')
                  : widget.post.likes.add('PedHu77dM0fVk1sGzniCZifIEHf1');
            }),
        icon: ImageIcon(
            const AssetImage(
              'assets/images/dashboard/thumbsUp.png',
            ),
            color: model.isBusy
                ? primaryColor
                : (widget.post.likes.contains(model.user.userId)
                    ? primaryColor
                    : scaffoldColor)));
  }
}
