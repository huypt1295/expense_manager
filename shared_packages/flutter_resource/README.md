# 🎨 flutter_resource

A comprehensive Flutter package providing centralized resources, themes, localization, and assets for the expense_manager application.

## 📋 Features

- **🎨 Multi-Theme Support**: Light, Dark, and Premier themes with Material 3
- **🌈 Rich Color System**: 10+ color palettes with semantic naming
- **✍️ Typography System**: Platform-aware fonts (SFUIText for iOS, Roboto for Android)
- **🌍 Internationalization**: English and Vietnamese localization (68+ translation keys)
- **🖼️ Asset Management**: Type-safe image and SVG loading utilities
- **💉 Dependency Injection**: Injectable micro-package support

## 📦 Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_resource:
    path: ../shared_packages/flutter_resource
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Setup Theme

```dart
import 'package:flutter_resource/flutter_resource.dart';

MaterialApp(
  title: 'My App',
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
  // ... other configurations
)
```

### 2. Setup Localization

```dart
MaterialApp(
  localizationsDelegates: [
    ...L10n.localizationsDelegates,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L10n.supportedLocales,
  // ... other configurations
)
```

### 3. Use in Your App

```dart
// Access localized strings
Text(L10n.of(context).appName)

// Use theme colors
Container(
  color: Theme.of(context).extension<AppColorSchemeExtension>()!.backgroundMain,
)

// Load images
TPImages.image('logo.png', width: 100, height: 100)

// Load SVG icons
TPImages.svg('icon.svg', color: Colors.blue)
```

## 🎨 Theme System

### Available Themes

| Theme | Description | Use Case |
|-------|-------------|----------|
| **Light** | Clean, bright interface | Default daytime theme |
| **Dark** | Easy on the eyes | Night mode, OLED displays |
| **Premier** | Premium gold accents | Special tier users |

### Accessing Theme Colors

```dart
// Via ColorScheme
final primary = Theme.of(context).colorScheme.primary;

// Via AppColorSchemeExtension for semantic colors
final ext = Theme.of(context).extension<AppColorSchemeExtension>()!;
final textColor = ext.textMain;
final bgColor = ext.backgroundMain;
final positiveColor = ext.textPositive;
```

### Color Palettes

The package includes comprehensive color palettes:

- **Primary**: Purple (Branding, Light, Dark, Premier variants)
- **Secondary**: Orange Branding, Gold Premier
- **Semantic**: Green (positive), Red (negative), Yellow (warning)
- **Accent**: Blue, Pink, Teal
- **Effects**: Dim Black, Dim White for overlays

> 💡 **Tip**: See [color_guide.html](color_guide.html) for a visual reference of all colors!

## ✍️ Typography

### Using Text Styles

```dart
import 'package:flutter_resource/flutter_resource.dart';

Text('Heading', style: TPTextStyle.h1)
Text('Body text', style: TPTextStyle.bodyM)
Text('Caption', style: TPTextStyle.captionS)
```

### Text Decorations

```dart
// Add underline
Text('Link', style: TPTextStyle.bodyM.underline)

// Add strikethrough
Text('Deleted', style: TPTextStyle.bodyM.strikethrough)
```

### Platform-Aware Fonts

The typography system automatically uses:
- **iOS**: SFUIText (weights: 300-800)
- **Android**: Roboto (weights: 100-900)

## 🖼️ Assets & Images

### Loading Images

```dart
// Raster images (PNG, JPG, WebP)
TPImages.image(
  'logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)

// SVG images with color tinting
TPImages.svg(
  'icon.svg',
  width: 24,
  height: 24,
  color: Colors.blue,
)

// Get ImageProvider for advanced use
final provider = TPImages.provider('background.jpg');
```

### Predefined Assets

```dart
// Social login icons
Image.asset(TPAssets.logoGoogle)
Image.asset(TPAssets.logoFB)
```

### Asset Structure

```
assets/
├── fonts/          # SFUIText and Roboto font files
├── images/         # PNG, JPG, WebP images
├── lotties/        # Lottie animation files
├── icon/           # Icon assets
└── json/           # JSON data files
```

## 🌍 Localization

### Supported Languages

- 🇬🇧 English (`en`)
- 🇻🇳 Vietnamese (`vi`)

### Using Translations

```dart
// With context
final s = L10n.of(context);
Text(s.appName)
Text(s.greeting) // Supports parameters

// Without context (use sparingly)
final s = L10n.current;
Text(s.save)
```

### Available Translation Keys

**Navigation**: `tab_home`, `tab_transactions`, `tab_budget`, `tab_profile`

**Transactions**: `add_transaction`, `edit_transaction`, `amount`, `category`, `expense`, `income`

**Budget**: `total_budget`, `budget_by_category`, `add_budget`, `edit_budget`

**Workspace**: `workspace`, `create_workspace`, `members`, `invite_members`, `leave_workspace`

**Settings**: `theme`, `language`, `setting`, `sign_out`

**Common**: `save`, `done`, `cancel`, `delete`, `see_all`

> 📝 See [intl_en.arb](lib/l10n/intl_en.arb) and [intl_vi.arb](lib/l10n/intl_vi.arb) for the complete list.

### Adding New Translations

1. Add keys to `lib/l10n/intl_en.arb` and `lib/l10n/intl_vi.arb`
2. Run code generation:
   ```bash
   flutter pub run intl_utils:generate
   ```

## 💉 Dependency Injection

This package supports injectable micro-package initialization:

```dart
import 'package:flutter_resource/flutter_resource.dart';

// In your DI setup
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
```

## 📚 API Reference

### Core Classes

| Class | Purpose | Location |
|-------|---------|----------|
| `AppTheme` | Theme factory | [app_theme.dart](lib/src/theme/app_theme.dart) |
| `AppColors` | Color constants | [colors.dart](lib/src/theme/colors.dart) |
| `ColorTokens` | MaterialColor tokens | [color_tokens.dart](lib/src/theme/color_tokens.dart) |
| `AppColorSchemeExtension` | Semantic color roles | [app_color_extension.dart](lib/src/theme/app_color_extension.dart) |
| `TPTextStyle` | Typography styles | [typography.dart](lib/src/theme/typography.dart) |
| `TPImages` | Image loading utilities | [images.dart](lib/src/resources/images.dart) |
| `TPAssets` | Asset path constants | [assets.dart](lib/src/resources/assets.dart) |
| `L10n` | Localization helpers | [localization.dart](lib/src/localization/localization.dart) |

### Enums

- `ThemeType`: `light`, `dark`, `premier`

## 🎯 Usage Examples

### Complete Theme Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_resource/flutter_resource.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      
      // Theme configuration
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      
      // Localization configuration
      localizationsDelegates: [
        ...L10n.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      
      home: HomePage(),
    );
  }
}
```

### Custom Themed Widget

```dart
class ThemedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorSchemeExtension>()!;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundSub,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderMain),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TPImages.svg('icon.svg', width: 32, height: 32),
          SizedBox(height: 8),
          Text(
            L10n.of(context).appName,
            style: TPTextStyle.h3.copyWith(color: colors.textMain),
          ),
          Text(
            L10n.of(context).greeting,
            style: TPTextStyle.bodyS.copyWith(color: colors.textSub),
          ),
        ],
      ),
    );
  }
}
```

### Dynamic Theme Switching

```dart
class ThemeSwitcher extends StatelessWidget {
  final ThemeType currentTheme;
  final ValueChanged<ThemeType> onThemeChanged;
  
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeType>(
      segments: [
        ButtonSegment(
          value: ThemeType.light,
          label: Text(L10n.of(context).theme_mode_light),
        ),
        ButtonSegment(
          value: ThemeType.dark,
          label: Text(L10n.of(context).theme_mode_dark),
        ),
        ButtonSegment(
          value: ThemeType.premier,
          label: Text('Premier'),
        ),
      ],
      selected: {currentTheme},
      onSelectionChanged: (Set<ThemeType> selected) {
        onThemeChanged(selected.first);
      },
    );
  }
}
```

## 🔧 Development

### Running Tests

```bash
flutter test
```

### Code Generation

For localization updates:

```bash
flutter pub run intl_utils:generate
```

For dependency injection:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📄 License

This package is part of the expense_manager project and is not published to pub.dev.

## 🤝 Contributing

This is a shared package within the expense_manager monorepo. When making changes:

1. Ensure backward compatibility
2. Update this README if adding new features
3. Add tests for new functionality
4. Run code generation if modifying localization or DI

## 📞 Support

For issues or questions, please refer to the main expense_manager project documentation.

---

**Made with ❤️ for the expense_manager project**
