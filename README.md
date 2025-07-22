# custom Picker

This is a multi-picker package that includes several different modes, making it easy to use.

## Features

- Easy integration.
- Customizable components.
- Performance optimized.
- Extensive documentation.
- Picker Ui Instagram.
- This is a multi-picker.


## Getting started

```yaml

import 'package:flutter_better_pickers/flutter_better_pickers.dart';

```

```yaml

  dependencies:
  flutter_better_pickers: ^0.0.3
      
       
```


## Usage



# use customPicker


## instagram pickers

<img width="300"  alt="picker8" src="https://github.com/user-attachments/assets/e892bbff-7245-4faa-b093-bc5d02081533" />


```dart
 List<AssetEntity> selectedAssetList = [];

  ElevatedButton(
        onPressed: ()  {
           var picker = const FlutterBetterPickers(
                maxCount: 5,
                requestType: MyRequestType.image,
              ).instagram(context);
            picker.then((value) {
             selectedAssetList = value;
          convertToFileList();
        });
       },
    child: const Text("Instgram picker"),
 ),

```

- OR

```dart
  onPressed: () {
          const FlutterBetterPickers(maxCount: 10, requestType: MyRequestType.image)
           .instagram(context)
          .then((onValue) {
         setState(() {
         selectedAssetList = onValue;
         convertToFileList();
     });
   });
},
```

## CustomPicker


<img src="https://github.com/user-attachments/assets/7c49d876-6890-4571-b2be-a19fad99936e" width="300"/>


```dart
ElevatedButton(
            onPressed: () {
                  var picker = const CustomPicker(
                     maxCount: 5,
                    requestType: MyRequestType.image,
                 ).getPicAssets(context);
               picker.then((value) {
            selectedAssetList = value;
          convertToFileList();
      });
    })
```


## BottomSheets

<img src="https://github.com/user-attachments/assets/6833ff88-69a1-4d5b-aa28-45368ae147bd" width="300"/>
<img src="https://github.com/user-attachments/assets/a5b5f91b-9871-4ef0-90e9-6403f049cf35" width="300"/>


```dart
ElevatedButton(
                onPressed: () {
                  var picker = FlutterBetterPickers.bottomSheets(
                    context: context,
                    maxCount: 5,
                    requestType: MyRequestType.image,
                  );
                  picker.then(
                    (value) {
                      setState(() {
                        selectedAssetList = value;
                        convertToFileList(); // تبدیل AssetEntity به فایل‌ها
                      });
                    },
                  );
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
  Here's a complete example of how to implement the TelegramMediaPickers in your Flutter app. This example shows how to select media files, convert them to a list of File, and prepare them for database storage.

```dart
import 'package:flutter/material.dart';
import 'package:telegram_media_pickers/telegram_media_pickers.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<TelegramMediaPickersState> _sheetKey = GlobalKey();
  
  List<File>? imageFiles = [];
  List<AssetEntity> selectedAssetList = [];

  void convertToFileList() async {
    List<File>? files = [];

    for (var asset in selectedAssetList) {
      final file = await asset.file; // Convert AssetEntity to File
      if (file != null) {
        files.add(file);
      }
    }
    setState(() {
      imageFiles = files; // Update the state with the list of files
    });
  }

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
              // Update the selectedAssetList
              if (assets != null) {
                selectedAssetList = assets;
                convertToFileList(); // Convert selected assets to files
              }

              if (files != null) {
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



```dart
elevatedButton(
 onPressed: () async {
 await FlutterBetterPickers.scaffoldBottomSheet(
 context: context,
 maxCount: 5,
 requestType: MyRequestType.image,
 confirmText: "Confirm",
 textEmptyList: "No album found",
 confirmButtonColor: Colors.blue,
 confirmTextColor: Colors.white,
 backgroundColor: Colors.white,
 textEmptyListColor: Colors.grey,
 backgroundSnackBarColor: Colors.red,
 ).then((value) {
 selectedAssetList = value;
 convertToFileList();
 });
 },
 child: const Text("scaffoldBottomSheet"),
 ),
```

## BottomSheetImageSelector


<img src="https://github.com/user-attachments/assets/67108a67-7b6a-45e3-9f66-1910569005b8" width="300"/>  <img src="https://github.com/user-attachments/assets/e67cd19e-adda-4766-a932-910dbd7956a3" width="300"/>


```dart

elevatedButton(
 onPressed: () async {
 await FlutterBetterPickers.bottomSheetImageSelector(
 cameraImageSettings: CameraImageSettings(),
 context: context,
 maxCount: 5,
 requestType: MyRequestType.image,
 confirmText: "Confirm",
 textEmptyList: "No album found",
 confirmButtonColor: Colors.blue,
 confirmTextColor: Colors.black,
 backgroundColor: Colors.white,
 textEmptyListColor: Colors.grey,
 backgroundSnackBarColor: Colors.red,
 ).then((value) {
 selectedAssetList = value;
 convertToFileList();
 });
 },
 child: const Text("bottomSheetImageSelector"),
 ),


```



## Additional information

If you have any issues, questions, or suggestions related to this package, please feel free to contact us at [swan.dev1993@gmail.com](mailto:swan.dev1993@gmail.com). We welcome your feedback and will do our best to address any problems or provide assistance.
For more information about this package, you can also visit our [GitHub repository](https://github.com/SwanFlutter/flutter_better_pickers) where you can find additional resources, contribute to the package's development, and file issues or bug reports. We appreciate your contributions and feedback, and we aim to make this package as useful as possible for our users.
Thank you for using our package, and we look forward to hearing from you!
