import 'package:flutter/widgets.dart';

class ResponsiveWidget {
  //Large screen is any screen whose width is more than 1200 pixels
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

//Small screen is any screen whose width is less than 800 pixels
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

//Medium screen is any screen whose width is less than 1200 pixels,
  //and more than 800 pixels
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 800 && MediaQuery.of(context).size.width < 1200;
  }

  ///  768 就算平板了，小于768，
  ///
  ///   其实还应该判断横屏，竖屏
  static bool isMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }
}
