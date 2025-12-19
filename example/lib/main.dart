import 'package:flutter/material.dart';
import 'package:flutter_better_pickers/flutter_better_pickers.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Better Pickers',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> selectedImages = [];
  List<String> selectedVideos = [];
  List<String> selectedAudio = [];
  List<String> selectedFiles = [];

  // GlobalKey for TelegramMediaPickers
  final GlobalKey<TelegramMediaPickersState> _telegramPickerKey = GlobalKey();

  // Language selection
  String _selectedLanguage = 'English';
  PickerLabels _currentLabels = PickerLabels.english;

  // Style selection
  String _selectedStyle = 'Light';
  PickerStyle _currentStyle = PickerStyle.light;

  final Map<String, PickerLabels> _languages = {
    'English': PickerLabels.english,
    'فارسی': PickerLabels.persian,
    'العربية': PickerLabels.arabic,
    'Deutsch': PickerLabels.german,
    'Français': PickerLabels.french,
  };

  final Map<String, PickerStyle> _styles = {
    'Light': PickerStyle.light,
    'Dark': PickerStyle.dark,
    'Telegram': PickerStyle.telegram,
    'Instagram': PickerStyle.instagram,
    'WhatsApp': PickerStyle.whatsapp,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Better Pickers'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // TelegramMediaPickers widget (invisible, uses overlay)
          TelegramMediaPickers(
            key: _telegramPickerKey,
            maxCountPickMedia: 5,
            requestType: MyRequestType.all,
            labels: _currentLabels,
            style: _currentStyle,
            onMediaPicked: (assets, files) {
              if (assets != null && assets.isNotEmpty) {
                setState(() {
                  selectedImages = assets;
                });
                _showSnackBar('Selected ${assets.length} media item(s)');
              }
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Language and Style Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Configuration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Language:',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    DropdownButton<String>(
                                      value: _selectedLanguage,
                                      isExpanded: true,
                                      items: _languages.keys.map((lang) {
                                        return DropdownMenuItem(
                                          value: lang,
                                          child: Text(lang),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedLanguage = value;
                                            _currentLabels = _languages[value]!;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Style:',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    DropdownButton<String>(
                                      value: _selectedStyle,
                                      isExpanded: true,
                                      items: _styles.keys.map((style) {
                                        return DropdownMenuItem(
                                          value: style,
                                          child: Text(style),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedStyle = value;
                                            _currentStyle = _styles[value]!;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 1. Custom Picker Button
                  _buildPickerButton(
                    label: '1. Custom Picker (Images & Videos)',
                    icon: Icons.image,
                    onPressed: () => _showCustomPicker(),
                  ),
                  const SizedBox(height: 12),

                  // 2. Bottom Sheet Button
                  _buildPickerButton(
                    label: '2. Bottom Sheet (Images)',
                    icon: Icons.photo_library,
                    onPressed: () => _showBottomSheet(),
                  ),
                  const SizedBox(height: 12),

                  // 3. Scaffold Bottom Sheet Button
                  _buildPickerButton(
                    label: '3. Scaffold Bottom Sheet (Images)',
                    icon: Icons.collections,
                    onPressed: () => _showScaffoldBottomSheet(),
                  ),
                  const SizedBox(height: 12),

                  // 4. Bottom Sheet Image Selector Button
                  _buildPickerButton(
                    label: '4. Bottom Sheet Image Selector',
                    icon: Icons.image_search,
                    onPressed: () => _showBottomSheetImageSelector(),
                  ),
                  const SizedBox(height: 12),

                  // 5. Instagram Style Picker Button
                  _buildPickerButton(
                    label: '5. Instagram Style Picker',
                    icon: Icons.camera_alt,
                    onPressed: () => _showInstagramPicker(),
                  ),
                  const SizedBox(height: 12),

                  // 6. Telegram Media Picker Button
                  _buildPickerButton(
                    label: '6. Telegram Media Picker',
                    icon: Icons.send,
                    onPressed: () => _showTelegramPicker(),
                  ),
                  const SizedBox(height: 24),

                  // Display selected items
                  if (selectedImages.isNotEmpty) ...[
                    _buildResultSection('Selected Images', selectedImages),
                    const SizedBox(height: 16),
                  ],
                  if (selectedVideos.isNotEmpty) ...[
                    _buildResultSection('Selected Videos', selectedVideos),
                    const SizedBox(height: 16),
                  ],
                  if (selectedAudio.isNotEmpty) ...[
                    _buildResultSection('Selected Audio', selectedAudio),
                    const SizedBox(height: 16),
                  ],
                  if (selectedFiles.isNotEmpty) ...[
                    _buildResultSection('Selected Files', selectedFiles),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildResultSection(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${items.length} item(s) selected',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isImage = [
                    '.jpg',
                    '.jpeg',
                    '.png',
                    '.gif',
                    '.bmp',
                    '.webp',
                  ].any((extension) => item.toLowerCase().endsWith(extension));

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: isImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(item),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Error',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.red,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text(
                                item.split('/').last,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Custom Picker Example
  Future<void> _showCustomPicker() async {
    final result = await FlutterBetterPicker.customPicker(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      labels: _currentLabels,
      style: _currentStyle,
    );

    if (result.isNotEmpty) {
      setState(() {
        selectedImages = result;
      });
      _showSnackBar('Selected ${result.length} image(s)');
    }
  }

  // 2. Bottom Sheet Example with Labels and Style
  Future<void> _showBottomSheet() async {
    final result = await FlutterBetterPicker.bottomSheets(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      confirmText: _currentLabels.confirmButtonText,
      textEmptyList: _currentLabels.noImagesFound,
      confirmTextColor: _currentStyle.confirmTextColor,
      confirmButtonColor: _currentStyle.confirmButtonColor,
      backgroundColor: _currentStyle.backgroundColor,
      textEmptyListColor: _currentStyle.emptyListTextColor,
      // NEW: Pass labels and style
      labels: _currentLabels,
      style: _currentStyle,
    );

    if (result.isNotEmpty) {
      setState(() {
        selectedImages = result;
      });
      _showSnackBar('Selected ${result.length} image(s)');
    }
  }

  // 3. Scaffold Bottom Sheet Example with Labels and Style
  Future<void> _showScaffoldBottomSheet() async {
    final result = await FlutterBetterPicker.scaffoldBottomSheet(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      confirmText: _currentLabels.confirmButtonText,
      textEmptyList: _currentLabels.noImagesFound,
      confirmTextColor: _currentStyle.confirmTextColor,
      confirmButtonColor: _currentStyle.confirmButtonColor,
      backgroundColor: _currentStyle.backgroundColor,
      // NEW: Pass labels and style
      labels: _currentLabels,
      style: _currentStyle,
    );

    if (result.isNotEmpty) {
      setState(() {
        selectedImages = result;
      });
      _showSnackBar('Selected ${result.length} image(s)');
    }
  }

  // 4. Bottom Sheet Image Selector Example with Labels and Style
  Future<void> _showBottomSheetImageSelector() async {
    final result = await FlutterBetterPicker.bottomSheetImageSelector(
      context: context,
      maxCount: 5,
      requestType: MyRequestType.image,
      confirmText: _currentLabels.confirmButtonText,
      textEmptyList: _currentLabels.noImagesFound,
      confirmTextColor: _currentStyle.confirmTextColor,
      confirmButtonColor: _currentStyle.confirmButtonColor,
      backgroundColor: _currentStyle.backgroundColor,
      // NEW: Pass labels and style
      labels: _currentLabels,
      style: _currentStyle,
    );

    if (result.isNotEmpty) {
      setState(() {
        selectedImages = result;
      });
      _showSnackBar('Selected ${result.length} image(s)');
    }
  }

  // 5. Instagram Style Picker Example
  Future<void> _showInstagramPicker() async {
    final picker = FlutterBetterPicker(
      maxCount: 5,
      requestType: MyRequestType.image,
      confirmText: 'Send',
      confirmTextColor: Colors.white,
      backgroundColor: const Color(0xFF2A2D3E),
      appbarColor: const Color(0xFF2A2D3E),
      textColor: Colors.white,
    );

    final result = await picker.instagram(context);

    if (result.isNotEmpty) {
      setState(() {
        selectedImages = result;
      });
      _showSnackBar('Selected ${result.length} image(s)');
    }
  }

  // 6. Telegram Media Picker Example
  void _showTelegramPicker() {
    // TelegramMediaPickers uses overlay system, call toggleSheet to show it
    _telegramPickerKey.currentState?.toggleSheet(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
