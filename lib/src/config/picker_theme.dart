import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/src/config/picker_labels.dart';
import 'package:flutter_better_pickers/src/config/picker_style.dart';

/// Global picker theme configuration
/// Use this to set a consistent theme across all pickers
class PickerTheme extends InheritedWidget {
  /// Style configuration for the picker
  final PickerStyle style;

  /// Labels for internationalization
  final PickerLabels labels;

  const PickerTheme({
    super.key,
    required this.style,
    required this.labels,
    required super.child,
  });

  /// Get the nearest PickerTheme from context
  static PickerTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PickerTheme>();
  }

  /// Get style from context or return default
  static PickerStyle styleOf(BuildContext context) {
    return of(context)?.style ?? const PickerStyle();
  }

  /// Get labels from context or return default
  static PickerLabels labelsOf(BuildContext context) {
    return of(context)?.labels ?? const PickerLabels();
  }

  @override
  bool updateShouldNotify(PickerTheme oldWidget) {
    return style != oldWidget.style || labels != oldWidget.labels;
  }
}

/// Extension to easily access picker theme from context
extension PickerThemeExtension on BuildContext {
  /// Get the current picker style
  PickerStyle get pickerStyle => PickerTheme.styleOf(this);

  /// Get the current picker labels
  PickerLabels get pickerLabels => PickerTheme.labelsOf(this);
}

/// Pre-built theme configurations for common use cases
class PickerThemes {
  PickerThemes._();

  /// Light theme with English labels
  static const lightEnglish = _PrebuiltTheme(
    style: PickerStyle.light,
    labels: PickerLabels.english,
  );

  /// Dark theme with English labels
  static const darkEnglish = _PrebuiltTheme(
    style: PickerStyle.dark,
    labels: PickerLabels.english,
  );

  /// Telegram style with English labels
  static const telegramEnglish = _PrebuiltTheme(
    style: PickerStyle.telegram,
    labels: PickerLabels.english,
  );

  /// Instagram style with English labels
  static const instagramEnglish = _PrebuiltTheme(
    style: PickerStyle.instagram,
    labels: PickerLabels.english,
  );

  /// WhatsApp style with English labels
  static const whatsappEnglish = _PrebuiltTheme(
    style: PickerStyle.whatsapp,
    labels: PickerLabels.english,
  );

  /// Telegram style with Persian labels
  static const telegramPersian = _PrebuiltTheme(
    style: PickerStyle.telegram,
    labels: PickerLabels.persian,
  );

  /// Dark theme with Persian labels
  static const darkPersian = _PrebuiltTheme(
    style: PickerStyle.dark,
    labels: PickerLabels.persian,
  );

  /// Dark theme with Arabic labels
  static const darkArabic = _PrebuiltTheme(
    style: PickerStyle.dark,
    labels: PickerLabels.arabic,
  );

  /// Light theme with French labels
  static const lightFrench = _PrebuiltTheme(
    style: PickerStyle.light,
    labels: PickerLabels.french,
  );

  /// Light theme with German labels
  static const lightGerman = _PrebuiltTheme(
    style: PickerStyle.light,
    labels: PickerLabels.german,
  );
}

/// Helper class for prebuilt themes
class _PrebuiltTheme {
  final PickerStyle style;
  final PickerLabels labels;

  const _PrebuiltTheme({required this.style, required this.labels});
}

/// Widget helper to easily wrap your app with a picker theme
class PickerThemeProvider extends StatelessWidget {
  final PickerStyle? style;
  final PickerLabels? labels;
  final _PrebuiltTheme? prebuiltTheme;
  final Widget child;

  /// Create with custom style and labels
  const PickerThemeProvider({
    super.key,
    this.style,
    this.labels,
    this.prebuiltTheme,
    required this.child,
  });

  /// Create with a prebuilt theme
  const PickerThemeProvider.prebuilt({
    super.key,
    required _PrebuiltTheme theme,
    required this.child,
  }) : prebuiltTheme = theme,
       style = null,
       labels = null;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = prebuiltTheme?.style ?? style ?? const PickerStyle();
    final effectiveLabels =
        prebuiltTheme?.labels ?? labels ?? const PickerLabels();

    return PickerTheme(
      style: effectiveStyle,
      labels: effectiveLabels,
      child: child,
    );
  }
}
