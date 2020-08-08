import 'package:flutter/material.dart';

enum DeviceType { Desktop, Mobile, Tablet }

class ScreenUtil {
  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _statusBarHeight;
  static double _bottomBarHeight;

  static void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;

    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
  }

  static DeviceType getDeviceType(MediaQueryData mediaQuery) {
    Orientation orientation = mediaQueryData.orientation;
    double width = 0;
    if (orientation == Orientation.landscape) {
      width = mediaQueryData.size.height;
    } else {
      width = mediaQueryData.size.width;
    }
    if (width >= 950) {
      return DeviceType.Desktop;
    }
    if (width >= 600) {
      return DeviceType.Tablet;
    }
    return DeviceType.Mobile;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;

  /// The horizontal extent of this size.
  static double get screenWidthDp => _screenWidth;

  ///The vertical extent of this size. dp
  static double get screenHeightDp => _screenHeight;

  static bool get portrait =>
      _mediaQueryData.orientation == Orientation.portrait;

  /// The offset from the top
  static double get statusBarHeight => _statusBarHeight;

  /// The offset from the bottom.
  static double get bottomBarHeight => _bottomBarHeight;
}
