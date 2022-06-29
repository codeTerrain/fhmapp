import 'dart:io';

import 'package:fhmapp/core/services/utilities.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked/stacked.dart';

import '../viewmodels/post_view_model.dart';
import '../widgets/appbars.dart';
import '../widgets/change_info.dart';
import '../widgets/misc.dart';
import '../widgets/neumorph_drop_down.dart';
import '../widgets/neumorph_textfield.dart';
import '../widgets/selected_images_view.dart';

class CreatePost extends StatefulWidget {
  final List<String>? fhmappAdminFor;
  const CreatePost({Key? key, this.fhmappAdminFor}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<File> imageFiles = [];

  final TextEditingController _contentController = TextEditingController();
  late String fhmappAdminFor;

  @override
  void initState() {
    fhmappAdminFor = widget.fhmappAdminFor![0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(widget.fhmappAdminFor![0]),

          imageFiles.isEmpty
              ? const SizedBox()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: UiSpacing.screenSize(context).width,
                      height: 100,
                      child: SelectedImages(imageFiles: imageFiles))),
          UiSpacing.verticalSpacingTiny(),
          Stack(
            children: [
              Container(
                height: 45,
                width: UiSpacing.screenSize(context).width,
                padding: containerPadding,
                decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(23))),
                child: Row(
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    galleryActions(
                        icon: Icons.camera_alt_outlined,
                        onPressed: () => buttonClicked(false)),
                    UiSpacing.horizontalSpacingTiny(),
                    galleryActions(
                        icon: Icons.photo_library,
                        onPressed: () => buttonClicked(true)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverInfoAppBar(
            title: Text(
              'Create a Post',
              style: Theme.of(context).textTheme.headline5,
            ),
            trailing: ViewModelBuilder<PostViewModel>.reactive(
              viewModelBuilder: () => PostViewModel(),
              builder: (context, model, child) => SizedBox(
                width: model.isBusy ? 100 : 60,
                height: 40,
                child: ButtonWrapper(
                  onPressed: () {
                    model
                        .post(
                            postId: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            category: fhmappAdminFor,
                            content: _contentController.text,
                            images: imageFiles)
                        .then((value) {
                      _contentController.clear();
                      imageFiles.clear();
                      setState(() {});
                    });
                  },
                  buttonText: model.isBusy ? 'Posting...' : ' Post',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: mainPadding,
            sliver: SliverToBoxAdapter(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 41),
                    decoration: BoxDecoration(
                        color: kWhite, borderRadius: generalBorderRadius),
                    height: UiSpacing.screenSize(context).height - 120,
                    width: UiSpacing.screenSize(context).width,
                    child: NeumorphTextField(
                      maxLength: 300,
                      isNeumorphic: false,
                      controller: _contentController,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                    ),
                  ),
                  Center(
                    child: NeumorphDropDown(
                      context,
                      width: 200,
                      dropItems: widget.fhmappAdminFor!,
                      hintText: 'Post For ',
                      prefixIcon: Image.asset('assets/images/login/user.png'),
                      value: fhmappAdminFor,
                      onChanged: (String? newValue) {
                        setState(() {
                          fhmappAdminFor = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future buttonClicked(bool isGallery) async {
    final CroppedFile? file = await Utilities.pickMedia(
      fileSize: 3.0,
      isGallery: isGallery,
      cropImage: (croppedFile) =>
          Utilities.cropSquareImage(croppedFile, CropStyle.rectangle),
    );

    if (imageFiles.length < 4) {
      if (file == null) return;
      var compressedFile = await Utilities.compressFile(File(file.path));
      setState(() => imageFiles.add(compressedFile!));
    } else {
      return;
    }
  }

  CircleAvatar galleryActions(
      {required IconData icon, required void Function()? onPressed}) {
    return CircleAvatar(
      radius: 17,
      backgroundColor: primaryColor,
      child: IconButton(
          icon: Icon(
            icon,
            size: 17,
            color: kWhite,
          ),
          onPressed: onPressed),
    );
  }
}
