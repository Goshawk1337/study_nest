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
    'early_morning_greeting': 'You’re up early, ',
    'morning_greeting': 'Good morning, ',
    'noon_greeting': 'Good noon, ',
    'afternoon_greeting': 'Good afternoon, ',
    'evening_greeting': 'Good evening, ',
    'night_greeting': 'Good night, ',
    'welcome': 'Welcome, ',
    'next_class': 'Next class',

    'change_language': 'Change Language',

    'avg': 'average',
  },
  'hu': {
    'early_morning_greeting': 'Korán érkeztél, ',
    'morning_greeting': 'Jó reggelt, ',
    'forenoon_greeting': 'Szép délelőttöt, ',
    'noon_greeting': 'Jó étvágyat ebédhez, ',
    'afternoon_greeting': 'Szép délutánt, ',
    'evening_greeting': 'Jó estét, ',
    'night_greeting': 'Jó éjszakát, ',
    'welcome': 'Üdv, ',
    'next_class': 'Következő óra',

    'change_language': 'Nyelv váltása',

    'avg': 'átlag',
  },
 
    // Add other languages
  };
}