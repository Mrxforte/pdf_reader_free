// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get appTitle => 'PDF Viewer Pro';

  @override
  String get home => 'Галоўная';

  @override
  String get allFiles => 'Усе файлы';

  @override
  String get favorites => 'Абранае';

  @override
  String get recent => 'Нядаўнія';

  @override
  String get settings => 'Налады';

  @override
  String get helpSupport => 'Дапамога і падтрымка';

  @override
  String get about => 'Пра праграму';

  @override
  String welcomeUser(Object name) {
    return 'Вітаем, $name!';
  }

  @override
  String fileCount(Object count) {
    return 'У вас $count PDF-файлаў';
  }

  @override
  String get recentFiles => 'Нядаўнія файлы';

  @override
  String get favoriteFiles => 'Абраныя файлы';

  @override
  String get viewAll => 'Паглядзець усё';

  @override
  String get noRecentFiles => 'Няма нядаўніх файлаў';

  @override
  String get noFavoriteFiles => 'Няма абраных файлаў';

  @override
  String get searchPdfFiles => 'Пошук PDF-файлаў...';

  @override
  String get noPdfFilesYet => 'Пакуль няма PDF-файлаў';

  @override
  String get tapPlusToAddFirst => 'Націсніце +, каб дадаць першы PDF';

  @override
  String get openedLabel => 'Адкрыта';

  @override
  String pageLabel(Object page) {
    return 'Старонка $page';
  }

  @override
  String get welcomeBack => 'З вяртаннем';

  @override
  String get signInToAccess => 'Увайдзіце, каб атрымаць доступ да PDF-файлаў';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get forgotPassword => 'Забылі пароль?';

  @override
  String get signIn => 'Увайсці';

  @override
  String get signUp => 'Зарэгістравацца';

  @override
  String get createAccount => 'Стварыць уліковы запіс';

  @override
  String get fullName => 'Поўнае імя';

  @override
  String get confirmPassword => 'Пацвердзіце пароль';

  @override
  String get passwordsDoNotMatch => 'Паролі не супадаюць';

  @override
  String get resetPassword => 'Скід пароля';

  @override
  String get resetInstructions =>
      'Увядзіце email, каб атрымаць інструкцыі па скідзе';

  @override
  String get sendResetEmail => 'Адправіць ліст для скіду';

  @override
  String get backToLogin => 'Вярнуцца да ўваходу';

  @override
  String get profile => 'Профіль';

  @override
  String get appSettings => 'Налады праграмы';

  @override
  String get pdfSettings => 'Налады PDF';

  @override
  String get account => 'Уліковы запіс';

  @override
  String get dangerZone => 'Небяспечная зона';

  @override
  String get darkMode => 'Цёмная тэма';

  @override
  String get toggleTheme => 'Пераключыць светлую/цёмную тэму';

  @override
  String get language => 'Мова';

  @override
  String get autoOpenLastFile => 'Аўтаадкрыццё апошняга файла';

  @override
  String get showThumbnails => 'Паказваць мініяцюры';

  @override
  String get defaultSaveLocation => 'Месца захавання па змаўчанні';

  @override
  String get privacySecurity => 'Прыватнасць і бяспека';

  @override
  String get backupSync => 'Рэзервовае капіраванне і сінхранізацыя';

  @override
  String get clearAllData => 'Ачысціць усе даныя';

  @override
  String get signOut => 'Выйсці';

  @override
  String versionLabel(Object version) {
    return 'Версія $version';
  }
}
