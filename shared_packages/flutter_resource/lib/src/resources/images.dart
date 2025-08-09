import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A class that provides easy access to image assets in the application.
class TPImages {
  /// Private constructor to prevent instantiation
  const TPImages._();

  /// Base path for all images
  static const String _basePath = 'assets/images';

  /// Get the full path for an image
  static String getImagePath(String imageName) => '$_basePath/$imageName';

  /// Load an image as an Image widget
  static Image image(
    String imageName, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      getImagePath(imageName),
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

    /// Load an SVG icon as a widget
  static Widget svg(String iconName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return SvgPicture.asset(
      getImagePath(iconName),
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }

  /// Load an image as an ImageProvider
  static ImageProvider provider(String imageName) {
    return AssetImage(getImagePath(imageName));
  }
}
