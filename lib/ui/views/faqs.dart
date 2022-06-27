import 'package:fhmapp/ui/shared/faqmap.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:flutter/material.dart';

import '../../core/model/expanding_item.dart';
import '../shared/style.dart';
import '../widgets/appbars.dart';
import '../widgets/custom_expansion_panel_list.dart';
import '../widgets/misc.dart';

class FAQs extends StatefulWidget {
  const FAQs({Key? key}) : super(key: key);

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(
        title: Text(
          'FAQs',
          style: Theme.of(context).textTheme.headline5,
        ),
        //  trailing: drawerCaller(context),
      ),
      body: SingleChildScrollView(
          physics: scrollPhysics,
          child: Padding(
              padding: mainPadding,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UiSpacing.verticalSpacingMedium(),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/general/foldedarmsdoctor.png',
                          scale: 1.6,
                        ),
                        UiSpacing.horizontalSpacingSmall(),
                        Column(
                          children: [
                            UiSpacing.verticalSpacingLarge(),
                            Text('How can we\nhelp you?',
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1.2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    UiSpacing.verticalSpacingSmall(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Popular Questions',
                          style: Theme.of(context).textTheme.headline3),
                    ),
                    UiSpacing.verticalSpacingSmall(),
                    CustomExpansionPanelList.radio(
                      dividerColor: scaffoldColor,
                      children: FaqMap.expandingItem
                          .map((item) => CustomExpansionPanelRadio(
                              value: item.title,
                              canTapOnHeader: true,
                              headerBuilder: (context, index) =>
                                  buildTile(item),
                              body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemCount:
                                        item.content.values.toList().length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.content.keys.toList()[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              ?.copyWith(color: kBlack),
                                        ),
                                        Text(
                                          item.content.values.toList()[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ))))
                          .toList(),
                    )
                  ]))),
    );
  }

  Widget buildTile(ExpandingItem expandingItem) => ListTile(
        shape: roundedListTileBorder,
        title: Text(expandingItem.title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
      );
}
