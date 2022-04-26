library dots_indicator;

import 'dart:math';
import 'package:flutter/material.dart';

import '../shared/style.dart';
import 'dots_decor.dart';

typedef OnTap = void Function(double position);

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final double position;
  final DotsDecorator decorator;
  final Axis axis;
  final bool reversed;
  final OnTap? onTap;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  DotsIndicator({
    Key? key,
    required this.dotsCount,
    this.position = 0.0,
    this.decorator = const DotsDecorator(),
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
  })  : assert(dotsCount > 0, 'dotsCount must be superior to zero'),
        assert(position >= 0, 'position must be superior or equals to zero'),
        assert(
          position < dotsCount,
          "position must be less than dotsCount",
        ),
        assert(
          decorator.colors.isEmpty || decorator.colors.length == dotsCount,
          "colors param in decorator must empty or have same length as dotsCount parameter",
        ),
        assert(
          decorator.activeColors.isEmpty ||
              decorator.activeColors.length == dotsCount,
          "activeColors param in decorator must empty or have same length as dotsCount parameter",
        ),
        assert(
          decorator.sizes.isEmpty || decorator.sizes.length == dotsCount,
          "sizes param in decorator must empty or have same length as dotsCount parameter",
        ),
        assert(
          decorator.activeSizes.isEmpty ||
              decorator.activeSizes.length == dotsCount,
          "activeSizes param in decorator must empty or have same length as dotsCount parameter",
        ),
        assert(
          decorator.shapes.isEmpty || decorator.shapes.length == dotsCount,
          "shapes param in decorator must empty or have same length as dotsCount parameter",
        ),
        assert(
          decorator.activeShapes.isEmpty ||
              decorator.activeShapes.length == dotsCount,
          "activeShapes param in decorator must empty or have same length as dotsCount parameter",
        ),
        super(key: key);

  Widget _wrapInkwell(Widget dot, int index) {
    return InkWell(
      customBorder: position == index
          ? decorator.getActiveShape(index)
          : decorator.getShape(index),
      onTap: () => onTap!(index.toDouble()),
      child: dot,
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final lerpValue = min(1.0, (position - index).abs());

    final size = Size.lerp(
      decorator.getActiveSize(index),
      decorator.getSize(index),
      lerpValue,
    )!;

    final dot = Container(
        width: size.width,
        height: size.height,
        margin: decorator.spacing,
        decoration: ShapeDecoration(
          color: Color.lerp(
            decorator.getActiveColor(index) ?? Theme.of(context).primaryColor,
            decorator.getColor(index),
            lerpValue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF2A8068)),
            //Border.all(color: primaryColor,  )
            //     ShapeBorder.lerp(
            //   decorator.getActiveShape(index),
            //   decorator.getShape(index),
            //   lerpValue,
            // )!,
          ),
        ));
    return onTap == null ? dot : _wrapInkwell(dot, index);
  }

  @override
  Widget build(BuildContext context) {
    final dotsList = List<Widget>.generate(
      dotsCount,
      (i) => _buildDot(context, i),
    );
    final dots = reversed ? dotsList.reversed.toList() : dotsList;

    return axis == Axis.vertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          );
  }
}

class Dots extends StatelessWidget {
  final double currentPage;
  final PageController pageController;
  const Dots(
      {Key? key, required this.pageController, required this.currentPage})
      : super(key: key);

  Future<void> animateScroll(int page) async {
    await pageController.animateToPage(
      max(min(page, 4), 0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Page ${currentPage.round() + 1} of 4",
      excludeSemantics: true,
      child: DotsIndicator(
        // reversed: widget.rtl,
        dotsCount: 4,
        position: currentPage,
        onTap: (pos) => animateScroll(pos.toInt()),
        decorator: const DotsDecorator(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          //  colors: [primaryColor],
          spacing: EdgeInsets.only(bottom: 0, right: 6),
          size: Size(12.0, 12.0),
          color: kWhite,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
