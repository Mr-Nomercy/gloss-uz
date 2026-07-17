import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const _supportedLocales = ['uz', 'ru', 'en'];

  static const _translations = <String, Map<String, String>>{
    'uz': {
      'appName': 'Gloss',
      'login': 'Kirish',
      'register': "Ro'yxatdan o'tish",
      'phone': 'Telefon raqam',
      'password': 'Parol',
      'search': 'Qidirish',
      'orders': 'Buyurtmalar',
      'profile': 'Profil',
      'home': 'Bosh sahifa',
      'logout': 'Chiqish',
      'save': 'Saqlash',
      'cancel': 'Bekor qilish',
      'confirm': 'Tasdiqlash',
      'loading': 'Yuklanmoqda...',
      'error': 'Xatolik yuz berdi',
      'retry': 'Qayta urinish',
      'noInternet': 'Internet aloqasi yo\'q',
      'hello': 'Xush kelibsiz',
      'settings': 'Sozlamalar',
      'language': 'Til',
      'notifications': 'Xabarnomalar',
      'location': 'Joylashuv',
    },
    'ru': {
      'appName': 'Gloss',
      'login': 'Войти',
      'register': 'Регистрация',
      'phone': 'Номер телефона',
      'password': 'Пароль',
      'search': 'Поиск',
      'orders': 'Заказы',
      'profile': 'Профиль',
      'home': 'Главная',
      'logout': 'Выйти',
      'save': 'Сохранить',
      'cancel': 'Отмена',
      'confirm': 'Подтвердить',
      'loading': 'Загрузка...',
      'error': 'Произошла ошибка',
      'retry': 'Повторить',
      'noInternet': 'Нет интернета',
      'hello': 'Добро пожаловать',
      'settings': 'Настройки',
      'language': 'Язык',
      'notifications': 'Уведомления',
      'location': 'Местоположение',
    },
    'en': {
      'appName': 'Gloss',
      'login': 'Login',
      'register': 'Register',
      'phone': 'Phone number',
      'password': 'Password',
      'search': 'Search',
      'orders': 'Orders',
      'profile': 'Profile',
      'home': 'Home',
      'logout': 'Logout',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'loading': 'Loading...',
      'error': 'An error occurred',
      'retry': 'Retry',
      'noInternet': 'No internet connection',
      'hello': 'Welcome',
      'settings': 'Settings',
      'language': 'Language',
      'notifications': 'Notifications',
      'location': 'Location',
    },
  };

  String translate(String key) {
    return _translations[locale.languageCode]?[key] ?? _translations['uz']?[key] ?? key;
  }
  
  String tr(String key) => translate(key);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['uz', 'ru', 'en'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
