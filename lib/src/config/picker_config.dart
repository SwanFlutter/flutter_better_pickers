import 'package:flutter_better_pickers/src/config/picker_labels.dart';
import 'package:flutter_better_pickers/src/config/picker_style.dart';

export 'picker_labels.dart';
export 'picker_style.dart';

/// A unified configuration class that combines labels and style for pickers.
class PickerConfig {
  /// Text labels for internationalization
  final PickerLabels labels;

  /// Style configuration for the picker
  final PickerStyle style;

  const PickerConfig({
    this.labels = const PickerLabels(),
    this.style = const PickerStyle(),
  });

  /// English configuration with light theme
  static const PickerConfig englishLight = PickerConfig(
    labels: PickerLabels.english,
    style: PickerStyle.light,
  );

  /// English configuration with dark theme
  static const PickerConfig englishDark = PickerConfig(
    labels: PickerLabels.english,
    style: PickerStyle.dark,
  );

  /// Persian configuration with light theme
  static const PickerConfig persianLight = PickerConfig(
    labels: PickerLabels.persian,
    style: PickerStyle.light,
  );

  /// Persian configuration with dark theme
  static const PickerConfig persianDark = PickerConfig(
    labels: PickerLabels.persian,
    style: PickerStyle.dark,
  );

  /// Arabic configuration with light theme
  static const PickerConfig arabicLight = PickerConfig(
    labels: PickerLabels.arabic,
    style: PickerStyle.light,
  );

  /// Arabic configuration with dark theme
  static const PickerConfig arabicDark = PickerConfig(
    labels: PickerLabels.arabic,
    style: PickerStyle.dark,
  );

  /// German configuration with light theme
  static const PickerConfig germanLight = PickerConfig(
    labels: PickerLabels.german,
    style: PickerStyle.light,
  );

  /// German configuration with dark theme
  static const PickerConfig germanDark = PickerConfig(
    labels: PickerLabels.german,
    style: PickerStyle.dark,
  );

  /// French configuration with light theme
  static const PickerConfig frenchLight = PickerConfig(
    labels: PickerLabels.french,
    style: PickerStyle.light,
  );

  /// French configuration with dark theme
  static const PickerConfig frenchDark = PickerConfig(
    labels: PickerLabels.french,
    style: PickerStyle.dark,
  );

  /// Telegram style with English labels
  static const PickerConfig telegramEnglish = PickerConfig(
    labels: PickerLabels.english,
    style: PickerStyle.telegram,
  );

  /// Instagram style with English labels
  static const PickerConfig instagramEnglish = PickerConfig(
    labels: PickerLabels.english,
    style: PickerStyle.instagram,
  );

  /// WhatsApp style with English labels
  static const PickerConfig whatsappEnglish = PickerConfig(
    labels: PickerLabels.english,
    style: PickerStyle.whatsapp,
  );

  /// Create a copy with modified values
  PickerConfig copyWith({
    PickerLabels? labels,
    PickerStyle? style,
  }) {
    return PickerConfig(
      labels: labels ?? this.labels,
      style: style ?? this.style,
    );
  }
}
