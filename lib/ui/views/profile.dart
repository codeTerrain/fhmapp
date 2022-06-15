import 'package:cached_network_image/cached_network_image.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../shared/style.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/misc.dart';
import '../widgets/tiles.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline5,
        ),
        trailing: drawerCaller(context),
      ),
      body: SingleChildScrollView(
        physics: scrollPhysics,
        child: Padding(
          padding: mainPadding,
          child: Column(
            children: [
              ViewModelBuilder<ProfileViewModel>.reactive(
                  viewModelBuilder: () => ProfileViewModel(),
                  onModelReady: (model) => model.getUserInfo(),
                  builder: (context, model, child) {
                    if (model.isBusy) {
                      return const CircularProgressIndicator();
                    } else {
                      return Column(
                        children: [
                          ClipOval(
                              child: model.user.profilePicture != ''
                                  ? CachedNetworkImage(
                                      imageUrl: (model.imageUrl == null ||
                                              model.imageUrl == '')
                                          ? model.user.profilePicture!
                                          : model.imageUrl!,
                                      errorWidget: (context, url, error) {
                                        return noProfile;
                                      },
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      placeholderFadeInDuration:
                                          const Duration(milliseconds: 200),
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      useOldImageOnUrlChange: true,
                                    )
                                  : noProfile),
                          UiSpacing.verticalSpacingTiny(),
                          Text("${model.user.firstName} ${model.user.lastName}",
                              style: Theme.of(context).textTheme.headline3),
                          Text(
                            model.user.email,
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(color: grey),
                          )
                        ],
                      );
                    }
                  }),
              UiSpacing.verticalSpacingMedium(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ProfileTile(
                          index,
                        ));
                  },
                  itemCount: 4),
              const SizedBox(
                height: 500,
              )
            ],
          ),
        ),
      ),
    );
  }
}
