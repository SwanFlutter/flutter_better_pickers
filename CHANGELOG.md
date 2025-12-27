## 0.0.8

* **Breaking Changes:**
  * Refactored all picker widgets to use `PickerLabels` and `PickerStyle` for better consistency.
  * Deprecated individual styling properties in favor of centralized `style` parameter.
  * Deprecated individual text properties in favor of centralized `labels` parameter.

* **New Features:**
  * Added 8 new languages to `PickerLabels`: Spanish, Italian, Russian, Turkish, Chinese (Simplified), Japanese, Korean, and Hindi.
  * Added comprehensive documentation to all picker widgets (`ScaffoldBottomSheet`, `CustomPicker`, `BottomSheets`, `BottomSheetImageSelector`).
  * All deprecated properties now have `@deprecated` annotations with migration guidance.

* **Improvements:**
  * Improved code maintainability by centralizing styling and localization.
  * Enhanced developer experience with detailed inline documentation and examples.
  * Better separation of concerns between UI styling and business logic.

* **Migration Guide:**
  * Replace individual color/text properties with `labels` and `style` parameters.
  * Use predefined styles: `PickerStyle.light`, `PickerStyle.dark`, `PickerStyle.telegram`, `PickerStyle.instagram`, `PickerStyle.whatsapp`.
  * Use predefined labels: `PickerLabels.english`, `PickerLabels.persian`, `PickerLabels.arabic`, etc.

## 0.0.7

* Update README.md


## 0.0.6

* Fix bug.

## 0.0.5

* **Maintenance:**
  * Bumped `permission_handler` to ^12.0.1.
  * Bumped `camera` to ^0.11.3.
  * Bumped `lucide_icons_flutter` to ^3.1.8.
  * Declared Android/iOS platform support in `pubspec.yaml`.


## 0.0.4

* **New Features:**
  * Added comprehensive theming system (`PickerTheme`) for consistent styling across all pickers.
  * Added `PickerStyle` for complete UI customization (colors, text styles, icons).
  * Added `PickerLabels` for internationalization (English, Persian, Arabic, German, French).
  * Added `MediaManagerConfig` for performance tuning and isolate configuration.
  * Added camera icon as the first grid item in TelegramMediaPickers.

* **Performance Improvements:**
  * Implemented `MediaCacheManager` with LRU eviction for efficient memory usage.
  * Implemented `MediaLoadingQueue` with concurrent operation limiting.
  * Optimized image loading with Flutter's built-in caching (`Image.file`).
  * Added in-memory caching for video thumbnails.
  * Enabled isolate support for heavy operations.

* **Bug Fixes:**
  * Fixed `RenderFlex overflow` error in TelegramMediaPickers bottom bar.
  * Fixed album selection dropdown appearing behind the sheet.
  * Fixed File and Audio screens using wrong background color (now uses theme).
  * Fixed toggle logic for File/Video/Audio buttons.
  * Fixed duplicate dropdown in expanded state.
  * Updated SDK to ^3.10.0.


## 0.0.3

* Fix bug.


## 0.0.1

* Add initial release.
