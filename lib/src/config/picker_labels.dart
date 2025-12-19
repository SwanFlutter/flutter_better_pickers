/// A class that contains all the text labels used in the media pickers.
/// This allows for easy internationalization and customization of text.
class PickerLabels {
  /// Title for the picker screen
  final String title;

  /// Text for select media header
  final String selectMedia;

  /// Text for gallery label
  final String gallery;

  /// Text for albums dropdown
  final String albums;

  /// Text for all photos
  final String allPhotos;

  /// Text for confirm/send button
  final String confirmButtonText;

  /// Text for cancel button
  final String cancelButtonText;

  /// Text when no media is found
  final String noMediaFound;

  /// Text when no albums are found
  final String noAlbumsFound;

  /// Text when no images are found
  final String noImagesFound;

  /// Text when no videos are found
  final String noVideosFound;

  /// Text when no audio is found
  final String noAudioFound;

  /// Text when no files are found
  final String noFilesFound;

  /// Text for images tab
  final String imagesTab;

  /// Text for videos tab
  final String videosTab;

  /// Text for audio tab
  final String audioTab;

  /// Text for files tab
  final String filesTab;

  /// Text for camera button
  final String camera;

  /// Text for selected count
  final String selected;

  /// Text for loading
  final String loading;

  /// Text for error
  final String error;

  /// Text for permission denied
  final String permissionDenied;

  /// Text for no media selected warning
  final String noMediaSelected;

  /// Text for max selection reached
  final String maxSelectionReached;

  /// Text for select album
  final String selectAlbum;

  /// Text for recent
  final String recent;

  /// Text for downloads folder
  final String downloads;

  /// Text for pictures folder
  final String pictures;

  /// Text for movies folder
  final String movies;

  /// Text for music folder
  final String music;

  /// Text for documents folder
  final String documents;

  const PickerLabels({
    this.title = 'Album',
    this.selectMedia = 'Select Media',
    this.gallery = 'Gallery',
    this.albums = 'Albums',
    this.allPhotos = 'All Photos',
    this.confirmButtonText = 'Send',
    this.cancelButtonText = 'Cancel',
    this.noMediaFound = 'No media found',
    this.noAlbumsFound = 'No albums found',
    this.noImagesFound = 'No images found',
    this.noVideosFound = 'No videos found',
    this.noAudioFound = 'No audio found',
    this.noFilesFound = 'No files found',
    this.imagesTab = 'Images',
    this.videosTab = 'Videos',
    this.audioTab = 'Audio',
    this.filesTab = 'Files',
    this.camera = 'Camera',
    this.selected = 'Selected',
    this.loading = 'Loading...',
    this.error = 'Error',
    this.permissionDenied = 'Permission denied',
    this.noMediaSelected = 'No media selected',
    this.maxSelectionReached = 'Maximum selection reached',
    this.selectAlbum = 'Select Album',
    this.recent = 'Recent',
    this.downloads = 'Downloads',
    this.pictures = 'Pictures',
    this.movies = 'Movies',
    this.music = 'Music',
    this.documents = 'Documents',
  });

  /// English labels (default)
  static const PickerLabels english = PickerLabels();

  /// Persian/Farsi labels
  static const PickerLabels persian = PickerLabels(
    title: 'آلبوم',
    selectMedia: 'انتخاب رسانه',
    gallery: 'گالری',
    albums: 'آلبوم‌ها',
    allPhotos: 'همه تصاویر',
    confirmButtonText: 'ارسال',
    cancelButtonText: 'انصراف',
    noMediaFound: 'رسانه‌ای یافت نشد',
    noAlbumsFound: 'آلبومی یافت نشد',
    noImagesFound: 'تصویری یافت نشد',
    noVideosFound: 'ویدیویی یافت نشد',
    noAudioFound: 'صوتی یافت نشد',
    noFilesFound: 'فایلی یافت نشد',
    imagesTab: 'تصاویر',
    videosTab: 'ویدیوها',
    audioTab: 'صوت',
    filesTab: 'فایل‌ها',
    camera: 'دوربین',
    selected: 'انتخاب شده',
    loading: 'در حال بارگذاری...',
    error: 'خطا',
    permissionDenied: 'دسترسی رد شد',
    noMediaSelected: 'رسانه‌ای انتخاب نشده',
    maxSelectionReached: 'حداکثر انتخاب',
    selectAlbum: 'انتخاب آلبوم',
    recent: 'اخیر',
    downloads: 'دانلودها',
    pictures: 'تصاویر',
    movies: 'فیلم‌ها',
    music: 'موسیقی',
    documents: 'اسناد',
  );

  /// Arabic labels
  static const PickerLabels arabic = PickerLabels(
    title: 'الألبوم',
    selectMedia: 'اختر الوسائط',
    gallery: 'المعرض',
    albums: 'الألبومات',
    allPhotos: 'جميع الصور',
    confirmButtonText: 'إرسال',
    cancelButtonText: 'إلغاء',
    noMediaFound: 'لم يتم العثور على وسائط',
    noAlbumsFound: 'لم يتم العثور على ألبومات',
    noImagesFound: 'لم يتم العثور على صور',
    noVideosFound: 'لم يتم العثور على فيديوهات',
    noAudioFound: 'لم يتم العثور على صوتيات',
    noFilesFound: 'لم يتم العثور على ملفات',
    imagesTab: 'الصور',
    videosTab: 'الفيديوهات',
    audioTab: 'الصوت',
    filesTab: 'الملفات',
    camera: 'الكاميرا',
    selected: 'محدد',
    loading: 'جاري التحميل...',
    error: 'خطأ',
    permissionDenied: 'تم رفض الإذن',
    noMediaSelected: 'لم يتم اختيار وسائط',
    maxSelectionReached: 'تم الوصول للحد الأقصى',
    selectAlbum: 'اختر الألبوم',
    recent: 'الأخيرة',
    downloads: 'التنزيلات',
    pictures: 'الصور',
    movies: 'الأفلام',
    music: 'الموسيقى',
    documents: 'المستندات',
  );

  /// German labels
  static const PickerLabels german = PickerLabels(
    title: 'Album',
    selectMedia: 'Medien auswählen',
    gallery: 'Galerie',
    albums: 'Alben',
    allPhotos: 'Alle Fotos',
    confirmButtonText: 'Senden',
    cancelButtonText: 'Abbrechen',
    noMediaFound: 'Keine Medien gefunden',
    noAlbumsFound: 'Keine Alben gefunden',
    noImagesFound: 'Keine Bilder gefunden',
    noVideosFound: 'Keine Videos gefunden',
    noAudioFound: 'Keine Audiodateien gefunden',
    noFilesFound: 'Keine Dateien gefunden',
    imagesTab: 'Bilder',
    videosTab: 'Videos',
    audioTab: 'Audio',
    filesTab: 'Dateien',
    camera: 'Kamera',
    selected: 'Ausgewählt',
    loading: 'Wird geladen...',
    error: 'Fehler',
    permissionDenied: 'Berechtigung verweigert',
    noMediaSelected: 'Keine Medien ausgewählt',
    maxSelectionReached: 'Maximum erreicht',
    selectAlbum: 'Album auswählen',
    recent: 'Zuletzt',
    downloads: 'Downloads',
    pictures: 'Bilder',
    movies: 'Filme',
    music: 'Musik',
    documents: 'Dokumente',
  );

  /// French labels
  static const PickerLabels french = PickerLabels(
    title: 'Album',
    selectMedia: 'Sélectionner les médias',
    gallery: 'Galerie',
    albums: 'Albums',
    allPhotos: 'Toutes les photos',
    confirmButtonText: 'Envoyer',
    cancelButtonText: 'Annuler',
    noMediaFound: 'Aucun média trouvé',
    noAlbumsFound: 'Aucun album trouvé',
    noImagesFound: 'Aucune image trouvée',
    noVideosFound: 'Aucune vidéo trouvée',
    noAudioFound: 'Aucun audio trouvé',
    noFilesFound: 'Aucun fichier trouvé',
    imagesTab: 'Images',
    videosTab: 'Vidéos',
    audioTab: 'Audio',
    filesTab: 'Fichiers',
    camera: 'Caméra',
    selected: 'Sélectionné',
    loading: 'Chargement...',
    error: 'Erreur',
    permissionDenied: 'Permission refusée',
    noMediaSelected: 'Aucun média sélectionné',
    maxSelectionReached: 'Maximum atteint',
    selectAlbum: 'Sélectionner un album',
    recent: 'Récent',
    downloads: 'Téléchargements',
    pictures: 'Images',
    movies: 'Films',
    music: 'Musique',
    documents: 'Documents',
  );

  /// Create a copy with modified values
  PickerLabels copyWith({
    String? title,
    String? selectMedia,
    String? gallery,
    String? albums,
    String? allPhotos,
    String? confirmButtonText,
    String? cancelButtonText,
    String? noMediaFound,
    String? noAlbumsFound,
    String? noImagesFound,
    String? noVideosFound,
    String? noAudioFound,
    String? noFilesFound,
    String? imagesTab,
    String? videosTab,
    String? audioTab,
    String? filesTab,
    String? camera,
    String? selected,
    String? loading,
    String? error,
    String? permissionDenied,
    String? noMediaSelected,
    String? maxSelectionReached,
    String? selectAlbum,
    String? recent,
    String? downloads,
    String? pictures,
    String? movies,
    String? music,
    String? documents,
  }) {
    return PickerLabels(
      title: title ?? this.title,
      selectMedia: selectMedia ?? this.selectMedia,
      gallery: gallery ?? this.gallery,
      albums: albums ?? this.albums,
      allPhotos: allPhotos ?? this.allPhotos,
      confirmButtonText: confirmButtonText ?? this.confirmButtonText,
      cancelButtonText: cancelButtonText ?? this.cancelButtonText,
      noMediaFound: noMediaFound ?? this.noMediaFound,
      noAlbumsFound: noAlbumsFound ?? this.noAlbumsFound,
      noImagesFound: noImagesFound ?? this.noImagesFound,
      noVideosFound: noVideosFound ?? this.noVideosFound,
      noAudioFound: noAudioFound ?? this.noAudioFound,
      noFilesFound: noFilesFound ?? this.noFilesFound,
      imagesTab: imagesTab ?? this.imagesTab,
      videosTab: videosTab ?? this.videosTab,
      audioTab: audioTab ?? this.audioTab,
      filesTab: filesTab ?? this.filesTab,
      camera: camera ?? this.camera,
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      permissionDenied: permissionDenied ?? this.permissionDenied,
      noMediaSelected: noMediaSelected ?? this.noMediaSelected,
      maxSelectionReached: maxSelectionReached ?? this.maxSelectionReached,
      selectAlbum: selectAlbum ?? this.selectAlbum,
      recent: recent ?? this.recent,
      downloads: downloads ?? this.downloads,
      pictures: pictures ?? this.pictures,
      movies: movies ?? this.movies,
      music: music ?? this.music,
      documents: documents ?? this.documents,
    );
  }
}
