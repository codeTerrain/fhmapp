import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fhmapp/ui/views/resources_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../shared/style.dart';
import '../widgets/misc.dart';
import 'chat_category.dart';
import 'dashboard.dart';
import 'elearning.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int? selectedIndex = 1;

  final List<Widget> _pages = <Widget>[
    const ResourcesCategory(),
    const Center(
        child: Icon(
      Icons.location_on_outlined,
      color: primaryColor,
      size: 300,
    )),
    const ELearning(),
    const ChatCategory()
  ];

  var _bottomNavIndex = 0;

  late Animation<double> animation;
  late CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.library_books_outlined,
    Icons.location_on_outlined,
    Icons.laptop_chromebook_sharp,
    //  Icons.laptop_chromebook_sharp,
    FeatherIcons.messageCircle,
  ];
  final iconCaption = <String>[
    'Resources',
    'Compendium',
    'E-Learning',
    'Chat',
    ''
  ];
  bool isDashboard = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: primaryColor,
        child: Image.asset('assets/images/general/crookedArrow.png'),
        onPressed: () => setState(() {
          isDashboard = true;
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 66,
        tabBuilder: (int index, bool isActive) {
          final color =
              isDashboard ? kBlack : (isActive ? primaryColor : kBlack);
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 25,
                color: color,
              ),
              const SizedBox(height: 3),
              Text(
                iconCaption[index],
                maxLines: 1,
                style: TextStyle(color: color, fontSize: 12),
              )
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 28,
        gapWidth: 100,
        rightCornerRadius: 28,
        onTap: (index) => setState(() {
          _bottomNavIndex = index;
          isDashboard = false;
        }),
        itemCount: 4,
      ),
      body: Padding(
          padding: mainPadding,
          child: isDashboard ? const Dashboard() : _pages[_bottomNavIndex]),
    );
  }
}
