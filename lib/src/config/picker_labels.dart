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

  /// Spanish labels
  static const PickerLabels spanish = PickerLabels(
    title: 'Álbum',
    selectMedia: 'Seleccionar medios',
    gallery: 'Galería',
    albums: 'Álbumes',
    allPhotos: 'Todas las fotos',
    confirmButtonText: 'Enviar',
    cancelButtonText: 'Cancelar',
    noMediaFound: 'No se encontraron medios',
    noAlbumsFound: 'No se encontraron álbumes',
    noImagesFound: 'No se encontraron imágenes',
    noVideosFound: 'No se encontraron videos',
    noAudioFound: 'No se encontró audio',
    noFilesFound: 'No se encontraron archivos',
    imagesTab: 'Imágenes',
    videosTab: 'Videos',
    audioTab: 'Audio',
    filesTab: 'Archivos',
    camera: 'Cámara',
    selected: 'Seleccionado',
    loading: 'Cargando...',
    error: 'Error',
    permissionDenied: 'Permiso denegado',
    noMediaSelected: 'No se seleccionaron medios',
    maxSelectionReached: 'Máximo alcanzado',
    selectAlbum: 'Seleccionar álbum',
    recent: 'Reciente',
    downloads: 'Descargas',
    pictures: 'Imágenes',
    movies: 'Películas',
    music: 'Música',
    documents: 'Documentos',
  );

  /// Italian labels
  static const PickerLabels italian = PickerLabels(
    title: 'Album',
    selectMedia: 'Seleziona media',
    gallery: 'Galleria',
    albums: 'Album',
    allPhotos: 'Tutte le foto',
    confirmButtonText: 'Invia',
    cancelButtonText: 'Annulla',
    noMediaFound: 'Nessun media trovato',
    noAlbumsFound: 'Nessun album trovato',
    noImagesFound: 'Nessuna immagine trovata',
    noVideosFound: 'Nessun video trovato',
    noAudioFound: 'Nessun audio trovato',
    noFilesFound: 'Nessun file trovato',
    imagesTab: 'Immagini',
    videosTab: 'Video',
    audioTab: 'Audio',
    filesTab: 'File',
    camera: 'Fotocamera',
    selected: 'Selezionato',
    loading: 'Caricamento...',
    error: 'Errore',
    permissionDenied: 'Permesso negato',
    noMediaSelected: 'Nessun media selezionato',
    maxSelectionReached: 'Massimo raggiunto',
    selectAlbum: 'Seleziona album',
    recent: 'Recente',
    downloads: 'Download',
    pictures: 'Immagini',
    movies: 'Film',
    music: 'Musica',
    documents: 'Documenti',
  );

  /// Russian labels
  static const PickerLabels russian = PickerLabels(
    title: 'Альбом',
    selectMedia: 'Выбрать медиа',
    gallery: 'Галерея',
    albums: 'Альбомы',
    allPhotos: 'Все фото',
    confirmButtonText: 'Отправить',
    cancelButtonText: 'Отмена',
    noMediaFound: 'Медиа не найдено',
    noAlbumsFound: 'Альбомы не найдены',
    noImagesFound: 'Изображения не найдены',
    noVideosFound: 'Видео не найдено',
    noAudioFound: 'Аудио не найдено',
    noFilesFound: 'Файлы не найдены',
    imagesTab: 'Изображения',
    videosTab: 'Видео',
    audioTab: 'Аудио',
    filesTab: 'Файлы',
    camera: 'Камера',
    selected: 'Выбрано',
    loading: 'Загрузка...',
    error: 'Ошибка',
    permissionDenied: 'Доступ запрещен',
    noMediaSelected: 'Медиа не выбрано',
    maxSelectionReached: 'Достигнут максимум',
    selectAlbum: 'Выбрать альбом',
    recent: 'Недавние',
    downloads: 'Загрузки',
    pictures: 'Изображения',
    movies: 'Фильмы',
    music: 'Музыка',
    documents: 'Документы',
  );

  /// Turkish labels
  static const PickerLabels turkish = PickerLabels(
    title: 'Albüm',
    selectMedia: 'Medya Seç',
    gallery: 'Galeri',
    albums: 'Albümler',
    allPhotos: 'Tüm Fotoğraflar',
    confirmButtonText: 'Gönder',
    cancelButtonText: 'İptal',
    noMediaFound: 'Medya bulunamadı',
    noAlbumsFound: 'Albüm bulunamadı',
    noImagesFound: 'Resim bulunamadı',
    noVideosFound: 'Video bulunamadı',
    noAudioFound: 'Ses bulunamadı',
    noFilesFound: 'Dosya bulunamadı',
    imagesTab: 'Resimler',
    videosTab: 'Videolar',
    audioTab: 'Ses',
    filesTab: 'Dosyalar',
    camera: 'Kamera',
    selected: 'Seçildi',
    loading: 'Yükleniyor...',
    error: 'Hata',
    permissionDenied: 'İzin reddedildi',
    noMediaSelected: 'Medya seçilmedi',
    maxSelectionReached: 'Maksimuma ulaşıldı',
    selectAlbum: 'Albüm Seç',
    recent: 'Son',
    downloads: 'İndirilenler',
    pictures: 'Resimler',
    movies: 'Filmler',
    music: 'Müzik',
    documents: 'Belgeler',
  );

  /// Chinese (Simplified) labels
  static const PickerLabels chinese = PickerLabels(
    title: '相册',
    selectMedia: '选择媒体',
    gallery: '图库',
    albums: '相册',
    allPhotos: '所有照片',
    confirmButtonText: '发送',
    cancelButtonText: '取消',
    noMediaFound: '未找到媒体',
    noAlbumsFound: '未找到相册',
    noImagesFound: '未找到图片',
    noVideosFound: '未找到视频',
    noAudioFound: '未找到音频',
    noFilesFound: '未找到文件',
    imagesTab: '图片',
    videosTab: '视频',
    audioTab: '音频',
    filesTab: '文件',
    camera: '相机',
    selected: '已选择',
    loading: '加载中...',
    error: '错误',
    permissionDenied: '权限被拒绝',
    noMediaSelected: '未选择媒体',
    maxSelectionReached: '已达到最大值',
    selectAlbum: '选择相册',
    recent: '最近',
    downloads: '下载',
    pictures: '图片',
    movies: '电影',
    music: '音乐',
    documents: '文档',
  );

  /// Japanese labels
  static const PickerLabels japanese = PickerLabels(
    title: 'アルバム',
    selectMedia: 'メディアを選択',
    gallery: 'ギャラリー',
    albums: 'アルバム',
    allPhotos: 'すべての写真',
    confirmButtonText: '送信',
    cancelButtonText: 'キャンセル',
    noMediaFound: 'メディアが見つかりません',
    noAlbumsFound: 'アルバムが見つかりません',
    noImagesFound: '画像が見つかりません',
    noVideosFound: '動画が見つかりません',
    noAudioFound: '音声が見つかりません',
    noFilesFound: 'ファイルが見つかりません',
    imagesTab: '画像',
    videosTab: '動画',
    audioTab: '音声',
    filesTab: 'ファイル',
    camera: 'カメラ',
    selected: '選択済み',
    loading: '読み込み中...',
    error: 'エラー',
    permissionDenied: '権限が拒否されました',
    noMediaSelected: 'メディアが選択されていません',
    maxSelectionReached: '最大選択数に達しました',
    selectAlbum: 'アルバムを選択',
    recent: '最近',
    downloads: 'ダウンロード',
    pictures: '写真',
    movies: '映画',
    music: '音楽',
    documents: 'ドキュメント',
  );

  /// Korean labels
  static const PickerLabels korean = PickerLabels(
    title: '앨범',
    selectMedia: '미디어 선택',
    gallery: '갤러리',
    albums: '앨범',
    allPhotos: '모든 사진',
    confirmButtonText: '보내기',
    cancelButtonText: '취소',
    noMediaFound: '미디어를 찾을 수 없습니다',
    noAlbumsFound: '앨범을 찾을 수 없습니다',
    noImagesFound: '이미지를 찾을 수 없습니다',
    noVideosFound: '동영상을 찾을 수 없습니다',
    noAudioFound: '오디오를 찾을 수 없습니다',
    noFilesFound: '파일을 찾을 수 없습니다',
    imagesTab: '이미지',
    videosTab: '동영상',
    audioTab: '오디오',
    filesTab: '파일',
    camera: '카메라',
    selected: '선택됨',
    loading: '로딩 중...',
    error: '오류',
    permissionDenied: '권한이 거부되었습니다',
    noMediaSelected: '미디어가 선택되지 않았습니다',
    maxSelectionReached: '최대 선택 수에 도달했습니다',
    selectAlbum: '앨범 선택',
    recent: '최근',
    downloads: '다운로드',
    pictures: '사진',
    movies: '영화',
    music: '음악',
    documents: '문서',
  );

  /// Hindi labels
  static const PickerLabels hindi = PickerLabels(
    title: 'एल्बम',
    selectMedia: 'मीडिया चुनें',
    gallery: 'गैलरी',
    albums: 'एल्बम',
    allPhotos: 'सभी फ़ोटो',
    confirmButtonText: 'भेजें',
    cancelButtonText: 'रद्द करें',
    noMediaFound: 'कोई मीडिया नहीं मिला',
    noAlbumsFound: 'कोई एल्बम नहीं मिला',
    noImagesFound: 'कोई छवि नहीं मिली',
    noVideosFound: 'कोई वीडियो नहीं मिला',
    noAudioFound: 'कोई ऑडियो नहीं मिला',
    noFilesFound: 'कोई फ़ाइल नहीं मिली',
    imagesTab: 'छवियाँ',
    videosTab: 'वीडियो',
    audioTab: 'ऑडियो',
    filesTab: 'फ़ाइलें',
    camera: 'कैमरा',
    selected: 'चयनित',
    loading: 'लोड हो रहा है...',
    error: 'त्रुटि',
    permissionDenied: 'अनुमति अस्वीकृत',
    noMediaSelected: 'कोई मीडिया चयनित नहीं',
    maxSelectionReached: 'अधिकतम चयन पहुँच गया',
    selectAlbum: 'एल्बम चुनें',
    recent: 'हाल का',
    downloads: 'डाउनलोड',
    pictures: 'चित्र',
    movies: 'फ़िल्में',
    music: 'संगीत',
    documents: 'दस्तावेज़',
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
