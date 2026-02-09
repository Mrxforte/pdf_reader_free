// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'PDF Viewer Pro';

  @override
  String get home => 'Басты бет';

  @override
  String get allFiles => 'Барлық файлдар';

  @override
  String get favorites => 'Таңдаулылар';

  @override
  String get recent => 'Соңғылар';

  @override
  String get settings => 'Баптаулар';

  @override
  String get helpSupport => 'Көмек және қолдау';

  @override
  String get about => 'Қолданба туралы';

  @override
  String welcomeUser(Object name) {
    return 'Қош келдіңіз, $name!';
  }

  @override
  String fileCount(Object count) {
    return 'Сізде $count PDF файлы бар';
  }

  @override
  String get recentFiles => 'Соңғы файлдар';

  @override
  String get favoriteFiles => 'Таңдаулы файлдар';

  @override
  String get viewAll => 'Барлығын көру';

  @override
  String get noRecentFiles => 'Соңғы файлдар жоқ';

  @override
  String get noFavoriteFiles => 'Таңдаулы файлдар жоқ';

  @override
  String get searchPdfFiles => 'PDF файлдарын іздеу...';

  @override
  String get noPdfFilesYet => 'PDF файлдары жоқ';

  @override
  String get tapPlusToAddFirst => 'Алғашқы PDF қосу үшін + түймесін басыңыз';

  @override
  String get openedLabel => 'Ашылған';

  @override
  String pageLabel(Object page) {
    return 'Бет $page';
  }

  @override
  String get welcomeBack => 'Қайта қош келдіңіз';

  @override
  String get signInToAccess => 'PDF файлдарыңызға кіру үшін кіріңіз';

  @override
  String get email => 'Эл. пошта';

  @override
  String get password => 'Құпиясөз';

  @override
  String get forgotPassword => 'Құпиясөзді ұмыттыңыз ба?';

  @override
  String get signIn => 'Кіру';

  @override
  String get signUp => 'Тіркелу';

  @override
  String get createAccount => 'Тіркелгі жасау';

  @override
  String get fullName => 'Толық аты';

  @override
  String get confirmPassword => 'Құпиясөзді растау';

  @override
  String get passwordsDoNotMatch => 'Құпиясөздер сәйкес емес';

  @override
  String get resetPassword => 'Құпиясөзді қалпына келтіру';

  @override
  String get resetInstructions =>
      'Қалпына келтіру нұсқауын алу үшін эл. поштаны енгізіңіз';

  @override
  String get sendResetEmail => 'Қалпына келтіру хатын жіберу';

  @override
  String get backToLogin => 'Кіруге қайту';

  @override
  String get profile => 'Профиль';

  @override
  String get appSettings => 'Қолданба баптаулары';

  @override
  String get pdfSettings => 'PDF баптаулары';

  @override
  String get account => 'Тіркелгі';

  @override
  String get dangerZone => 'Қауіпті аймақ';

  @override
  String get darkMode => 'Қараңғы режим';

  @override
  String get toggleTheme => 'Қараңғы/жарық режимді ауыстыру';

  @override
  String get language => 'Тіл';

  @override
  String get autoOpenLastFile => 'Соңғы файлды автоматты ашу';

  @override
  String get showThumbnails => 'Нобайларды көрсету';

  @override
  String get defaultSaveLocation => 'Әдепкі сақтау орны';

  @override
  String get privacySecurity => 'Құпиялылық және қауіпсіздік';

  @override
  String get backupSync => 'Сақтық көшірме және синхрондау';

  @override
  String get clearAllData => 'Барлық деректерді тазалау';

  @override
  String get signOut => 'Шығу';

  @override
  String versionLabel(Object version) {
    return 'Нұсқа $version';
  }
}
