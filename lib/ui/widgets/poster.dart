import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fhmapp/core/services/utilities.dart';
import 'package:fhmapp/ui/viewmodels/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/post_model.dart';
import '../shared/spacing.dart';
import '../shared/style.dart';
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

    const verticalEdgeInsets = EdgeInsets.symmetric(vertical: 12);
    return Container(
      margin: verticalEdgeInsets,
      decoration: boxDecoration,
      padding: verticalEdgeInsets,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          programmeTag(context,
              text: post.category,
              style: Theme.of(context).textTheme.headline4),
          Text(
            formatTime(post.date),
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: transGrey),
          )
        ]),
        UiSpacing.verticalSpacingSmall(),
        (post.images != null && post.images!.isNotEmpty)
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: CarouselSlider(
                      items: post.images?.map((image) {
                        return ClipRRect(
                          borderRadius: generalBorderRadius,
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.fitWidth,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    LinearProgressIndicator(
                              value: downloadProgress.progress,
                              color: secondary1,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      }).toList(),
                      carouselController: _carouselController,
                      options: CarouselOptions(
                          viewportFraction: 2,
                          aspectRatio: 4 / 5,
                          enableInfiniteScroll: false),
                    ),
                  ),
                  Visibility(
                    visible: post.images!.length < 2 ? false : true,
                    child: Padding(
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
        UiSpacing.verticalSpacingTiny(),
        Container(padding: containerPadding, child: ActionRow(post: post))
      ]),
    );
  }
}

class ActionRow extends StatelessWidget {
  final Post post;
  const ActionRow({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ViewModelBuilder<ProfileViewModel>.reactive(
          viewModelBuilder: () => ProfileViewModel(),
          onModelReady: (model) => model.getUserInfo(),
          builder: (context, model, child) {
            if (model.isBusy) {
              return const SizedBox();
            }

            return like(context, model);
          },
        ),
        UiSpacing.horizontalSpacingTiny(),
        Text(post.likes.length.toString(),
            style: Theme.of(context).textTheme.bodyText2),
        const Spacer(),
        post.content != null ? share(context) : const SizedBox()
      ],
    );
  }

  IconButton share(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final List<String> urls = await Utilities.findPath(post.images!);
          if (post.images != null && post.images!.isNotEmpty) {
            await Share.shareFiles(urls, text: post.content);
          } else {
            await Share.share(post.content!);
          }
        },

        // Clipboard.setData(ClipboardData(
        //       text: post.content,
        //     )).then((_) => Utilities.showSnackBar(context,
        //         width: 110, text: 'Text copied!')),
        icon: const Icon(
          Icons.share,
          color: primaryColor,
        ));
  }

  Widget like(BuildContext context, ProfileViewModel userModel) {
    return ViewModelBuilder<PostViewModel>.reactive(
        viewModelBuilder: () => PostViewModel(),
        builder: (context, postModel, child) {
          return IconButton(
              onPressed: () => postModel.updateLikes(
                  post: post, currentUserEmail: userModel.user.email),
              icon: Icon(
                  // const AssetImage(
                  //   'assets/images/dashboard/thumbsUp.png',
                  // ),
                  postModel.isBusy
                      ? Icons.thumb_up
                      : ((post.likes.contains(userModel.user.email)
                          ? Icons.thumb_up
                          : Icons.thumb_up_alt_outlined)),
                  color: primaryColor));
        });
  }
}
