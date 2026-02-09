// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'PDF Viewer Pro';

  @override
  String get home => 'Bosh sahifa';

  @override
  String get allFiles => 'Barcha fayllar';

  @override
  String get favorites => 'Sevimlilar';

  @override
  String get recent => 'So\'nggi';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get helpSupport => 'Yordam va qo\'llab-quvvatlash';

  @override
  String get about => 'Ilova haqida';

  @override
  String welcomeUser(Object name) {
    return 'Xush kelibsiz, $name!';
  }

  @override
  String fileCount(Object count) {
    return 'Sizda $count ta PDF fayl bor';
  }

  @override
  String get recentFiles => 'So\'nggi fayllar';

  @override
  String get favoriteFiles => 'Sevimli fayllar';

  @override
  String get viewAll => 'Barchasini ko\'rish';

  @override
  String get noRecentFiles => 'So\'nggi fayllar yo\'q';

  @override
  String get noFavoriteFiles => 'Sevimli fayllar yo\'q';

  @override
  String get searchPdfFiles => 'PDF fayllarni qidirish...';

  @override
  String get noPdfFilesYet => 'Hozircha PDF fayllar yo\'q';

  @override
  String get tapPlusToAddFirst =>
      'Birinchi PDFni qo\'shish uchun + tugmasini bosing';

  @override
  String get openedLabel => 'Ochilgan';

  @override
  String pageLabel(Object page) {
    return 'Sahifa $page';
  }

  @override
  String get welcomeBack => 'Xush kelibsiz';

  @override
  String get signInToAccess => 'PDF fayllaringizga kirish uchun tizimga kiring';

  @override
  String get email => 'Email';

  @override
  String get password => 'Parol';

  @override
  String get forgotPassword => 'Parolni unutdingizmi?';

  @override
  String get signIn => 'Kirish';

  @override
  String get signUp => 'Ro\'yxatdan o\'tish';

  @override
  String get createAccount => 'Hisob yaratish';

  @override
  String get fullName => 'To\'liq ism';

  @override
  String get confirmPassword => 'Parolni tasdiqlang';

  @override
  String get passwordsDoNotMatch => 'Parollar mos emas';

  @override
  String get resetPassword => 'Parolni tiklash';

  @override
  String get resetInstructions =>
      'Tiklash ko\'rsatmalarini olish uchun emailingizni kiriting';

  @override
  String get sendResetEmail => 'Tiklash xatini yuborish';

  @override
  String get backToLogin => 'Kirishga qaytish';

  @override
  String get profile => 'Profil';

  @override
  String get appSettings => 'Ilova sozlamalari';

  @override
  String get pdfSettings => 'PDF sozlamalari';

  @override
  String get account => 'Hisob';

  @override
  String get dangerZone => 'Xavfli zona';

  @override
  String get darkMode => 'Qorong\'i rejim';

  @override
  String get toggleTheme => 'Qorong\'i/yorug\' rejimni almashtirish';

  @override
  String get language => 'Til';

  @override
  String get autoOpenLastFile => 'So\'nggi faylni avtomatik ochish';

  @override
  String get showThumbnails => 'Miniatyuralarni ko\'rsatish';

  @override
  String get defaultSaveLocation => 'Standart saqlash joyi';

  @override
  String get privacySecurity => 'Maxfiylik va xavfsizlik';

  @override
  String get backupSync => 'Zaxira nusxa va sinxronlash';

  @override
  String get clearAllData => 'Barcha ma\'lumotlarni tozalash';

  @override
  String get signOut => 'Chiqish';

  @override
  String versionLabel(Object version) {
    return 'Versiya $version';
  }
}
