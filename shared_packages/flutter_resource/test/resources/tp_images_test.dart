import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TPImages', () {
    const imageName = 'example.png';

    test('getImagePath resolves asset path', () {
      expect(TPImages.getImagePath(imageName), 'assets/images/$imageName');
    });

    test('image creates Image.asset with provided configuration', () {
      const color = Colors.red;
      final imageWidget = TPImages.image(
        imageName,
        width: 24,
        height: 48,
        fit: BoxFit.cover,
        color: color,
      );

      expect(imageWidget, isA<Image>());
      expect(imageWidget.width, 24);
      expect(imageWidget.height, 48);
      expect(imageWidget.fit, BoxFit.cover);
      expect(imageWidget.color, color);

      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/$imageName');
    });

    test('svg creates SvgPicture.asset with color filter applied when provided', () {
      const iconName = 'icon.svg';
      const color = Colors.blue;

      final widget = TPImages.svg(
        iconName,
        width: 12,
        height: 24,
        fit: BoxFit.contain,
        color: color,
      );

      expect(widget, isA<SvgPicture>());
      final svgWidget = widget as SvgPicture;

      expect(svgWidget.width, 12);
      expect(svgWidget.height, 24);
      expect(svgWidget.fit, BoxFit.contain);
      expect(svgWidget.colorFilter, const ColorFilter.mode(color, BlendMode.srcIn));

      expect(svgWidget.bytesLoader, isA<SvgAssetLoader>());
      final loader = svgWidget.bytesLoader as SvgAssetLoader;
      expect(loader.assetName, 'assets/images/$iconName');
      expect(loader.packageName, isNull);
    });

    test('provider returns expected AssetImage', () {
      final provider = TPImages.provider(imageName);
      expect(provider, isA<AssetImage>());
      expect((provider as AssetImage).assetName, 'assets/images/$imageName');
    });
  });

  group('TPAssets', () {
    test('contains known asset paths', () {
      expect(
        TPAssets.logoGoogle,
        'shared_packages/flutter_resource/assets/images/ic_google.webp',
      );
      expect(
        TPAssets.logoFB,
        'shared_packages/flutter_resource/assets/images/ic_facebook.webp',
      );
    });
  });

  group('TPAnims', () {
    test('loading animation path is exposed', () {
      expect(
        TPAnims.loading,
        'shared_packages/flutter_resource/assets/lotties/lottie_loading.json',
      );
    });
  });
}
