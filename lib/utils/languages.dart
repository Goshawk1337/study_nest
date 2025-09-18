import 'package:get/get.dart';

class AppTranslations extends Translations {
  static final Map<String, String> languageNames = {
    'en': 'English',
    'hu': 'Magyar'
    // add more as needed
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'title': 'What the sigma',
      'welcome': 'Welcome to our multilingual Flutter app!',
      'change_language': 'Change Language',
    },
    'hu': {
      'title': 'स्थानीयीकरण एप्प',
      'welcome': 'हमारे बहुभाषीक Flutter एप्प में आपका स्वागत है!',
      'change_language': 'भाषा बदलें',
    },
 
    // Add other languages
  };
}