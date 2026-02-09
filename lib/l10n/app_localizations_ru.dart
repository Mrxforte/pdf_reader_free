// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'PDF Viewer Pro';

  @override
  String get home => 'Главная';

  @override
  String get allFiles => 'Все файлы';

  @override
  String get favorites => 'Избранное';

  @override
  String get recent => 'Недавние';

  @override
  String get settings => 'Настройки';

  @override
  String get helpSupport => 'Помощь и поддержка';

  @override
  String get about => 'О приложении';

  @override
  String welcomeUser(Object name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String fileCount(Object count) {
    return 'У вас $count PDF-файлов';
  }

  @override
  String get recentFiles => 'Недавние файлы';

  @override
  String get favoriteFiles => 'Избранные файлы';

  @override
  String get viewAll => 'Показать все';

  @override
  String get noRecentFiles => 'Нет недавних файлов';

  @override
  String get noFavoriteFiles => 'Нет избранных файлов';

  @override
  String get searchPdfFiles => 'Поиск PDF-файлов...';

  @override
  String get noPdfFilesYet => 'Пока нет PDF-файлов';

  @override
  String get tapPlusToAddFirst => 'Нажмите +, чтобы добавить первый PDF';

  @override
  String get openedLabel => 'Открыто';

  @override
  String pageLabel(Object page) {
    return 'Страница $page';
  }

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get signInToAccess => 'Войдите, чтобы получить доступ к PDF-файлам';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get fullName => 'Полное имя';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get resetPassword => 'Сброс пароля';

  @override
  String get resetInstructions =>
      'Введите email, чтобы получить инструкции по сбросу';

  @override
  String get sendResetEmail => 'Отправить письмо для сброса';

  @override
  String get backToLogin => 'Вернуться ко входу';

  @override
  String get profile => 'Профиль';

  @override
  String get appSettings => 'Настройки приложения';

  @override
  String get pdfSettings => 'Настройки PDF';

  @override
  String get account => 'Аккаунт';

  @override
  String get dangerZone => 'Опасная зона';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get toggleTheme => 'Переключить светлую/тёмную тему';

  @override
  String get language => 'Язык';

  @override
  String get autoOpenLastFile => 'Автооткрытие последнего файла';

  @override
  String get showThumbnails => 'Показывать миниатюры';

  @override
  String get defaultSaveLocation => 'Место сохранения по умолчанию';

  @override
  String get privacySecurity => 'Конфиденциальность и безопасность';

  @override
  String get backupSync => 'Резервное копирование и синхронизация';

  @override
  String get clearAllData => 'Очистить все данные';

  @override
  String get signOut => 'Выйти';

  @override
  String versionLabel(Object version) {
    return 'Версия $version';
  }
}
