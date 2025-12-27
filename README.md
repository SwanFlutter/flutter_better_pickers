# Flutter Better Pickers

This is a multi-picker package that includes several different modes, making it easy to use.

## Features

- Easy integration with minimal setup.
- Comprehensive theming system with `PickerStyle` and `PickerLabels`.
- Performance optimized with built-in caching and isolate support.
- Extensive documentation with inline examples.
- Multiple picker styles: Instagram, Telegram, WhatsApp, and more.
- Telegram-style media picker with File, Video, and Audio support.
- Multi-selection support with customizable limits.
- **NEW in 0.0.8:** Support for 13 languages (English, Persian, Arabic, German, French, Spanish, Italian, Russian, Turkish, Chinese, Japanese, Korean, Hindi).
- **NEW in 0.0.8:** Centralized styling with `PickerStyle` (light, dark, telegram, instagram, whatsapp).
- **NEW in 0.0.8:** Comprehensive documentation for all picker widgets.
- Camera integration with customizable quality settings.
- Folder/Album selection with media count display.


## Getting started

```yaml

import 'package:flutter_better_pickers/flutter_better_pickers.dart';

```

```yaml

  dependencies:
  flutter_better_pickers: ^0.0.8
       
       
```


## Internationalization

Flutter Better Pickers supports 13 languages out of the box:

```dart
// Available languages:
PickerLabels.english    // English
PickerLabels.persian    // فارسی (Persian)
PickerLabels.arabic     // العربية (Arabic)
PickerLabels.german     // Deutsch (German)
PickerLabels.french     // Français (French)
PickerLabels.spanish    // Español (Spanish)
PickerLabels.italian    // Italiano (Italian)
PickerLabels.russian    // Русский (Russian)
PickerLabels.turkish    // Türkçe (Turkish)
PickerLabels.chinese    // 简体中文 (Chinese Simplified)
PickerLabels.japanese   // 日本語 (Japanese)
PickerLabels.korean     // 한국어 (Korean)
PickerLabels.hindi      // हिन्दी (Hindi)
```

### Custom Labels

You can also create custom labels:

```dart
final customLabels = PickerLabels(
  title: 'My Gallery',
  confirmButtonText: 'Done',
  gallery: 'Photos',
  allPhotos: 'All Photos',
  // ... other properties
);

FlutterBetterPicker(
  maxCount: 5,
  requestType: MyRequestType.image,
  labels: customLabels,
  style: PickerStyle.light,
)
```

## Styling

Use predefined styles or create custom ones:

```dart
// Predefined styles:
PickerStyle.light       // Light theme
PickerStyle.dark        // Dark theme
PickerStyle.telegram    // Telegram-style
PickerStyle.instagram   // Instagram-style
PickerStyle.whatsapp    // WhatsApp-style

// Custom style:
final customStyle = PickerStyle(
  backgroundColor: Colors.white,
  primaryColor: Colors.blue,
  textColor: Colors.black,
  // ... other properties
);
```

## Usage Examples


## Instagram Pickers

<img width="300"  alt="picker8" src="https://github.com/user-attachments/assets/e892bbff-7245-4faa-b093-bc5d02081533" />

### Basic Usage

```dart
List<String> selectedMediaPaths = [];

ElevatedButton(
  onPressed: () {
    var picker = const FlutterBetterPicker(
      maxCount: 5,
      requestType: MyRequestType.image,
    ).instagram(context);
    picker.then((value) {
      selectedMediaPaths = value;
    });
  },
  child: const Text("Instagram picker"),
),
```

### With Custom Labels and Style

```dart
ElevatedButton(
  onPressed: () {
    FlutterBetterPicker(
      maxCount: 10,
      requestType: MyRequestType.image,
      labels: PickerLabels.persian, // or .english, .spanish, etc.
      style: PickerStyle.instagram,  // or .dark, .light, etc.
    ).instagram(context).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("Instagram picker"),
),
```

## CustomPicker

<img src="https://github.com/user-attachments/assets/7c49d876-6890-4571-b2be-a19fad99936e" width="300"/>

A tabbed picker with separate views for images and videos.

### Basic Usage

```dart
ElevatedButton(
  onPressed: () {
    FlutterBetterPicker.customPicker(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
    ).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("Custom Picker"),
)
```

### With Internationalization

```dart
ElevatedButton(
  onPressed: () {
    FlutterBetterPicker.customPicker(
      context: context,
      maxCount: 10,
      requestType: MyRequestType.all,
      labels: PickerLabels.chinese, // Supports 13 languages
      style: PickerStyle.telegram,
    ).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("Custom Picker"),
)
```


## BottomSheets

<img src="https://github.com/user-attachments/assets/6833ff88-69a1-4d5b-aa28-45368ae147bd" width="300"/>
<img src="https://github.com/user-attachments/assets/a5b5f91b-9871-4ef0-90e9-6403f049cf35" width="300"/>

A bottom sheet with dropdown folder selection.

```dart
ElevatedButton(
  onPressed: () {
    FlutterBetterPicker.bottomSheets(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      labels: PickerLabels.arabic,
      style: PickerStyle.dark,
    ).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("BottomSheet"),
),
```

## TelegramMediaPickers

<img src="https://github.com/user-attachments/assets/532a963d-bbd1-4b3c-ab92-0189a6107e53" width="300"/>
<img src="https://github.com/user-attachments/assets/426e7fda-e176-43e7-9c68-1412651e5935" width="300"/>

- Step 1: Create a GlobalKey
  Start by creating a GlobalKey to manage the state of the TelegramMediaPickers widget.

```dart
final GlobalKey<TelegramMediaPickersState> _sheetKey = GlobalKey();

```

- Step 2: Create a Button to Open the Picker
  Next, create a button that will open the media picker when pressed.

```dart
ElevatedButton(
  onPressed: () {
    // Open the TelegramMediaPickers
    _sheetKey.currentState?.toggleSheet(context);
  },
  child: const Text("Open Telegram Pickers"),
),

```

- Step 3: Implement the TelegramMediaPickers Widget
  Add the TelegramMediaPickers widget to your widget tree. It's important to set the requestType to a general value (like MyRequestType.all) to ensure that all types of media (images, videos, files) are displayed. Avoid changing this to a more specific type if you want the user to have access to all media options.

```dart
TelegramMediaPickers(
  key: _sheetKey,
  requestType: MyRequestType.all, // Set to 'all' to display images, videos, and files
  maxCountPickMedia: 5, // Maximum number of media that can be selected
  primeryColor: Colors.green, // Primary color for the UI
  isRealCameraView: false, // Set to true to use the real camera view
  onMediaPicked: (assets, files) {
    if (files != null) {
      for (var file in files) {
        debugPrint(file.path); // Print the path of selected files
      }
    } else if (assets != null) {
      for (var asset in assets) {
        debugPrint("Asset: ${asset.file}"); // Print the asset details
      }
    }
  },
),


```

- Complete Example
  Here's a complete example of how to implement the TelegramMediaPickers in your Flutter app. This example shows how to select media files and handle them.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<TelegramMediaPickersState> _sheetKey = GlobalKey();
  
  List<String> selectedMediaPaths = [];
  List<File> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Open and close TelegramMediaPickers
                _sheetKey.currentState?.toggleSheet(context);
                setState(() {});
              },
              child: const Text("Telegram Pickers"),
            ),
          ),

          // TelegramMediaPickers widget
        TelegramMediaPickers(
            key: _sheetKey,
            requestType: MyRequestType.all, // Set to 'all' to display all media types
            maxCountPickMedia: 5,
            maxCountPickFiles: 5,
            primeryColor: Colors.green,
            isRealCameraView: false,
            onMediaPicked: (assets, files) {
              if (assets != null) {
                setState(() {
                  selectedMediaPaths = assets;
                });
              }

              if (files != null) {
                setState(() {
                  selectedFiles = files;
                });
                for (var file in files) {
                  debugPrint(file.path); // Print the path of selected files
                }
              }
            },
          )
        ],
      ),
    );
  }
}
```

## scaffoldBottomSheet

<img src="https://github.com/user-attachments/assets/d5469b1e-5e80-4b86-971c-3ce906274e40" width="300"/>

A full-screen scaffold-based bottom sheet picker.

### Recommended Usage (v0.0.8+)

```dart
ElevatedButton(
  onPressed: () async {
    await FlutterBetterPicker.scaffoldBottomSheet(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      labels: PickerLabels.spanish,
      style: PickerStyle.light,
    ).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("scaffoldBottomSheet"),
),
```

### Legacy Usage (Deprecated)

```dart
// Note: Individual styling properties are deprecated in v0.0.8
// Use 'labels' and 'style' parameters instead
ElevatedButton(
  onPressed: () async {
    await FlutterBetterPicker.scaffoldBottomSheet(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      confirmText: "Confirm",  // @deprecated
      textEmptyList: "No album found",  // @deprecated
      confirmButtonColor: Colors.blue,  // @deprecated
      confirmTextColor: Colors.white,  // @deprecated
      backgroundColor: Colors.white,  // @deprecated
      textEmptyListColor: Colors.grey,  // @deprecated
      backgroundSnackBarColor: Colors.red,  // @deprecated
    ).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("scaffoldBottomSheet"),
),
```

## BottomSheetImageSelector

<img src="https://github.com/user-attachments/assets/67108a67-7b6a-45e3-9f66-1910569005b8" width="300"/>  <img src="https://github.com/user-attachments/assets/e67cd19e-adda-4766-a932-910dbd7956a3" width="300"/>

An Instagram-style picker with large preview at the top.

### Recommended Usage (v0.0.8+)

```dart
ElevatedButton(
  onPressed: () async {
    await FlutterBetterPicker.bottomSheetImageSelector(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      labels: PickerLabels.italian,
      style: PickerStyle.instagram,
      cameraImageSettings: CameraImageSettings(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      ),
    ).then((value) {
      setState(() {
        selectedMediaPaths = value;
      });
    });
  },
  child: const Text("bottomSheetImageSelector"),
),
```

## Migration Guide (v0.0.7 → v0.0.8)

If you're upgrading from v0.0.7, replace individual styling properties with centralized `labels` and `style`:

**Before (v0.0.7):**
```dart
FlutterBetterPicker(
  maxCount: 5,
  requestType: MyRequestType.image,
  confirmText: 'Send',
  confirmTextColor: Colors.white,
  backgroundColor: Colors.black,
  textColor: Colors.white,
)
```

**After (v0.0.8):**
```dart
FlutterBetterPicker(
  maxCount: 5,
  requestType: MyRequestType.image,
  labels: PickerLabels.english,  // or any other language
  style: PickerStyle.dark,        // or custom style
)
```



## Additional information

If you have any issues, questions, or suggestions related to this package, please feel free to contact us at [swan.dev1993@gmail.com](mailto:swan.dev1993@gmail.com). We welcome your feedback and will do our best to address any problems or provide assistance.
For more information about this package, you can also visit our [GitHub repository](https://github.com/SwanFlutter/flutter_better_pickers) where you can find additional resources, contribute to the package's development, and file issues or bug reports. We appreciate your contributions and feedback, and we aim to make this package as useful as possible for our users.
Thank you for using our package, and we look forward to hearing from you!
