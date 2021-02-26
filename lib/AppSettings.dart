import 'package:shared_preferences/shared_preferences.dart';

/// Shared Preferences ozelliginin kullanımı hakkında
/// official flutter sayfasindan yararlandim.
/// https://flutter.dev/docs/cookbook/persistence/key-value

const String APP_THEME_KEY = "appTheme";
const String DARK_APP_THEME_VALUE = "dark";
const String LIGHT_APP_THEME_VALUE = "light";

bool isDarkTheme = false;

class AppSettings {

  static Future<void> AppThemeChanger() async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(APP_THEME_KEY) ?? LIGHT_APP_THEME_VALUE;
    if(value == LIGHT_APP_THEME_VALUE){
      preferences.setString(APP_THEME_KEY, DARK_APP_THEME_VALUE);
      isDarkTheme = true;
    } else if (value == DARK_APP_THEME_VALUE){
      preferences.setString(APP_THEME_KEY, LIGHT_APP_THEME_VALUE);
      isDarkTheme = false;
    }
  }

  static Future<void> AppThemeReader () async {
    final preferences = await SharedPreferences.getInstance();
    final value = preferences.getString(APP_THEME_KEY) ?? LIGHT_APP_THEME_VALUE;

    if(value == LIGHT_APP_THEME_VALUE){
      isDarkTheme = false;
    } else if (value == DARK_APP_THEME_VALUE){
      isDarkTheme = true;
    }
  }

  static Future<void> RemoveSettingKey (String key) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}