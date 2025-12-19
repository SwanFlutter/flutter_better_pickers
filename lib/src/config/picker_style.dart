import 'package:flutter/material.dart';

/// A class that contains all the style configurations for the media pickers.
/// This allows for unified styling across all picker widgets.
class PickerStyle {
  /// Background color of the picker
  final Color backgroundColor;

  /// App bar background color
  final Color appBarColor;

  /// Primary color used for selection indicators, buttons, etc.
  final Color primaryColor;

  /// Color for confirm/send button
  final Color confirmButtonColor;

  /// Text color for confirm button
  final Color confirmTextColor;

  /// Color for icons
  final Color iconColor;

  /// Color for text
  final Color textColor;

  /// Color for secondary text (subtitles, hints)
  final Color secondaryTextColor;

  /// Color for empty list text
  final Color emptyListTextColor;

  /// Color for snackbar background
  final Color snackBarColor;

  /// Color for dropdown background
  final Color dropdownColor;

  /// Color for selection overlay
  final Color selectionOverlayColor;

  /// Color for selection badge
  final Color selectionBadgeColor;

  /// Color for tab indicator
  final Color tabIndicatorColor;

  /// Color for unselected tab
  final Color unselectedTabColor;

  /// Color for grid item border
  final Color gridItemBorderColor;

  /// Border radius for grid items
  final double gridItemBorderRadius;

  /// Border radius for buttons
  final double buttonBorderRadius;

  /// Border radius for bottom sheet
  final double bottomSheetBorderRadius;

  /// Padding for grid
  final EdgeInsets gridPadding;

  /// Spacing between grid items
  final double gridSpacing;

  /// Number of columns in grid
  final int gridCrossAxisCount;

  /// Text style for title
  final TextStyle? titleTextStyle;

  /// Text style for button
  final TextStyle? buttonTextStyle;

  /// Text style for dropdown
  final TextStyle? dropdownTextStyle;

  /// Text style for empty list
  final TextStyle? emptyListTextStyle;

  /// Icon for camera
  final Widget? cameraIcon;

  /// Icon for back button
  final Widget? backIcon;

  /// Custom loading widget
  final Widget? loadingWidget;

  const PickerStyle({
    this.backgroundColor = Colors.white,
    this.appBarColor = Colors.blue,
    this.primaryColor = Colors.blue,
    this.confirmButtonColor = Colors.blue,
    this.confirmTextColor = Colors.white,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.secondaryTextColor = Colors.grey,
    this.emptyListTextColor = Colors.grey,
    this.snackBarColor = Colors.red,
    this.dropdownColor = Colors.white,
    this.selectionOverlayColor = const Color(0x99FFFFFF),
    this.selectionBadgeColor = Colors.blue,
    this.tabIndicatorColor = Colors.blue,
    this.unselectedTabColor = Colors.grey,
    this.gridItemBorderColor = Colors.transparent,
    this.gridItemBorderRadius = 0,
    this.buttonBorderRadius = 8,
    this.bottomSheetBorderRadius = 20,
    this.gridPadding = const EdgeInsets.all(8),
    this.gridSpacing = 4,
    this.gridCrossAxisCount = 3,
    this.titleTextStyle,
    this.buttonTextStyle,
    this.dropdownTextStyle,
    this.emptyListTextStyle,
    this.cameraIcon,
    this.backIcon,
    this.loadingWidget,
  });

  /// Default light theme style
  static const PickerStyle light = PickerStyle(
    backgroundColor: Colors.white,
    appBarColor: Colors.blue,
    primaryColor: Colors.blue,
    confirmButtonColor: Colors.blue,
    confirmTextColor: Colors.white,
    iconColor: Colors.black,
    textColor: Colors.black,
    secondaryTextColor: Colors.grey,
    emptyListTextColor: Colors.grey,
    snackBarColor: Colors.red,
    dropdownColor: Colors.white,
    selectionOverlayColor: Color(0x99FFFFFF),
    selectionBadgeColor: Colors.blue,
    tabIndicatorColor: Colors.blue,
    unselectedTabColor: Colors.grey,
  );

  /// Dark theme style
  static const PickerStyle dark = PickerStyle(
    backgroundColor: Color(0xFF1E1E1E),
    appBarColor: Color(0xFF2C2C2C),
    primaryColor: Colors.blueAccent,
    confirmButtonColor: Colors.blueAccent,
    confirmTextColor: Colors.white,
    iconColor: Colors.white,
    textColor: Colors.white,
    secondaryTextColor: Color(0xFFAAAAAA),
    emptyListTextColor: Color(0xFF888888),
    snackBarColor: Colors.redAccent,
    dropdownColor: Color(0xFF2C2C2C),
    selectionOverlayColor: Color(0x66000000),
    selectionBadgeColor: Colors.blueAccent,
    tabIndicatorColor: Colors.blueAccent,
    unselectedTabColor: Color(0xFF888888),
  );

  /// Telegram-like style
  static const PickerStyle telegram = PickerStyle(
    backgroundColor: Color(0xFF17212B),
    appBarColor: Color(0xFF17212B),
    primaryColor: Color(0xFF5EBBFF),
    confirmButtonColor: Color(0xFF5EBBFF),
    confirmTextColor: Colors.white,
    iconColor: Colors.white,
    textColor: Colors.white,
    secondaryTextColor: Color(0xFF8B9BA5),
    emptyListTextColor: Color(0xFF8B9BA5),
    snackBarColor: Color(0xFFE53935),
    dropdownColor: Color(0xFF232E3C),
    selectionOverlayColor: Color(0x665EBBFF),
    selectionBadgeColor: Color(0xFF5EBBFF),
    tabIndicatorColor: Color(0xFF5EBBFF),
    unselectedTabColor: Color(0xFF8B9BA5),
  );

  /// Instagram-like style
  static const PickerStyle instagram = PickerStyle(
    backgroundColor: Color(0xFF121212),
    appBarColor: Color(0xFF121212),
    primaryColor: Color(0xFFE1306C),
    confirmButtonColor: Color(0xFF0095F6),
    confirmTextColor: Colors.white,
    iconColor: Colors.white,
    textColor: Colors.white,
    secondaryTextColor: Color(0xFFA8A8A8),
    emptyListTextColor: Color(0xFFA8A8A8),
    snackBarColor: Color(0xFFED4956),
    dropdownColor: Color(0xFF262626),
    selectionOverlayColor: Color(0x660095F6),
    selectionBadgeColor: Color(0xFF0095F6),
    tabIndicatorColor: Color(0xFF0095F6),
    unselectedTabColor: Color(0xFFA8A8A8),
  );

  /// WhatsApp-like style
  static const PickerStyle whatsapp = PickerStyle(
    backgroundColor: Color(0xFF111B21),
    appBarColor: Color(0xFF1F2C34),
    primaryColor: Color(0xFF00A884),
    confirmButtonColor: Color(0xFF00A884),
    confirmTextColor: Colors.white,
    iconColor: Color(0xFF8696A0),
    textColor: Colors.white,
    secondaryTextColor: Color(0xFF8696A0),
    emptyListTextColor: Color(0xFF8696A0),
    snackBarColor: Color(0xFFEA4335),
    dropdownColor: Color(0xFF1F2C34),
    selectionOverlayColor: Color(0x6600A884),
    selectionBadgeColor: Color(0xFF00A884),
    tabIndicatorColor: Color(0xFF00A884),
    unselectedTabColor: Color(0xFF8696A0),
  );

  /// Create a copy with modified values
  PickerStyle copyWith({
    Color? backgroundColor,
    Color? appBarColor,
    Color? primaryColor,
    Color? confirmButtonColor,
    Color? confirmTextColor,
    Color? iconColor,
    Color? textColor,
    Color? secondaryTextColor,
    Color? emptyListTextColor,
    Color? snackBarColor,
    Color? dropdownColor,
    Color? selectionOverlayColor,
    Color? selectionBadgeColor,
    Color? tabIndicatorColor,
    Color? unselectedTabColor,
    Color? gridItemBorderColor,
    double? gridItemBorderRadius,
    double? buttonBorderRadius,
    double? bottomSheetBorderRadius,
    EdgeInsets? gridPadding,
    double? gridSpacing,
    int? gridCrossAxisCount,
    TextStyle? titleTextStyle,
    TextStyle? buttonTextStyle,
    TextStyle? dropdownTextStyle,
    TextStyle? emptyListTextStyle,
    Widget? cameraIcon,
    Widget? backIcon,
    Widget? loadingWidget,
  }) {
    return PickerStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      appBarColor: appBarColor ?? this.appBarColor,
      primaryColor: primaryColor ?? this.primaryColor,
      confirmButtonColor: confirmButtonColor ?? this.confirmButtonColor,
      confirmTextColor: confirmTextColor ?? this.confirmTextColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      emptyListTextColor: emptyListTextColor ?? this.emptyListTextColor,
      snackBarColor: snackBarColor ?? this.snackBarColor,
      dropdownColor: dropdownColor ?? this.dropdownColor,
      selectionOverlayColor: selectionOverlayColor ?? this.selectionOverlayColor,
      selectionBadgeColor: selectionBadgeColor ?? this.selectionBadgeColor,
      tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
      unselectedTabColor: unselectedTabColor ?? this.unselectedTabColor,
      gridItemBorderColor: gridItemBorderColor ?? this.gridItemBorderColor,
      gridItemBorderRadius: gridItemBorderRadius ?? this.gridItemBorderRadius,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      bottomSheetBorderRadius: bottomSheetBorderRadius ?? this.bottomSheetBorderRadius,
      gridPadding: gridPadding ?? this.gridPadding,
      gridSpacing: gridSpacing ?? this.gridSpacing,
      gridCrossAxisCount: gridCrossAxisCount ?? this.gridCrossAxisCount,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      dropdownTextStyle: dropdownTextStyle ?? this.dropdownTextStyle,
      emptyListTextStyle: emptyListTextStyle ?? this.emptyListTextStyle,
      cameraIcon: cameraIcon ?? this.cameraIcon,
      backIcon: backIcon ?? this.backIcon,
      loadingWidget: loadingWidget ?? this.loadingWidget,
    );
  }
}
