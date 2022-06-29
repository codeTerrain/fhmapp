import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fhmapp/core/services/resource_download_service.dart';
import 'package:fhmapp/ui/shared/static_lists.dart';
import 'package:fhmapp/ui/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';
import '../../core/model/resource_model.dart';
import '../../core/services/respository.dart';
import '../../core/services/shared_preferences.dart';
import '../../locator.dart';
import '../shared/style.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/misc.dart';
import 'create_resource.dart';

class Resources extends StatelessWidget {
  final String categoryKey;
  final String categoryValue;
  const Resources(
      {Key? key, required this.categoryKey, required this.categoryValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverInfoAppBar(
            title: Text(
              'Resources',
              style: Theme.of(context).textTheme.headline5,
            ),
            subTitle: Text(
              programs[categoryKey]!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: primaryColor),
            ),
            trailing: ViewModelBuilder<ProfileViewModel>.reactive(
                viewModelBuilder: () => ProfileViewModel(),
                onModelReady: (model) => model.getUserInfo(),
                builder: (context, model, child) {
                  if (model.isBusy) {
                    return const SizedBox();
                  }
                  return (model.user.fhmappAdminFor != null &&
                          model.user.fhmappAdminFor!.contains(categoryValue))
                      ? newPostCaller(context, model.user.fhmappAdminFor,
                          CreateResource(fhmappAdminCategory: categoryKey))
                      : const SizedBox();
                }),
          ),
          ViewModelBuilder<ResourceService>.reactive(
              viewModelBuilder: () => ResourceService(),
              onModelReady: (model) => model.getAllResources(categoryKey),
              builder: (context, model, child) {
                List<Resource> allResources = model.resources;

                return SliverPadding(
                    padding: mainPadding,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ResourceTile(resource: allResources[index]);
                      }, childCount: allResources.length),
                    ));
              }),
        ],
      ),
    );
  }
}

class ResourceTile extends StatelessWidget {
  final Resource resource;
  const ResourceTile({
    required this.resource,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          shape: roundedListTileBorder,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          tileColor: kWhite,
          leading: Image.asset(
            'assets/images/logos/ghs_logo.png',
            scale: 2,
          ),
          title: Text(
            resource.name,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(color: grey),
          ),
          trailing: Downloader(resource: resource),
        ));
  }
}

class Downloader extends StatefulWidget {
  const Downloader({
    Key? key,
    required this.resource,
  }) : super(key: key);

  final Resource resource;

  @override
  State<Downloader> createState() => _DownloaderState();
}

class _DownloaderState extends State<Downloader> {
  late String _downloadProgress;
  late bool isRemote;
  final SharedPrefs _sharedPrefs = locator<SharedPrefs>();
  final Respository _respository = locator<Respository>();

  downloadResource(BuildContext context, Resource resource) async {
    var dio = Dio();
    String resourceName = resource.name;

    try {
      String path = await ResourceService().getLocalPath();
      String fullpath =
          '$path/${resource.category}/$resourceName.${resource.extension}';

      File downloadedResource = File(fullpath);

      if (await downloadedResource.exists()) {
        OpenFile.open(fullpath);
      } else {
        String url = resource.path;

        await dio.download(
          url,
          fullpath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              if (mounted) {
                setState(() {
                  _downloadProgress =
                      (received / total * 100).toStringAsFixed(0) + "%";
                });
              }
            }
          },
        ).then((value) async {
          await _sharedPrefs.setLocalStorage(resource.id, resource.name);
          await ResourceService().updateResourceDownloads(resource: resource);
        }).onError((e, s) {
          print(e);
          ResourceService.deleteFile(downloadedResource);
          return;
        });
        if (mounted) {
          setState(() {
            isRemote = false;
            _downloadProgress = widget.resource.extension;
          });
        }

        OpenFile.open(fullpath);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(' File Downloaded')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'An error occurred while downloading the file. Please try again later. Thank you.')));
    }
  }

  @override
  void initState() {
    super.initState();
    _downloadProgress = widget.resource.extension;
    isRemote = widget.resource.isRemote;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => downloadResource(context, widget.resource),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2),
        constraints: const BoxConstraints.expand(width: 55),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              FeatherIcons.download,
              color: kWhite,
            ),
            Text(
              _downloadProgress.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: kWhite),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: isRemote ? primaryColor : secondary1,
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
