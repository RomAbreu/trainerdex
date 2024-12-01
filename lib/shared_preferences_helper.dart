import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _pref;
  static SharedPreferencesHelper? _instance;

  SharedPreferencesHelper._();

  static SharedPreferencesHelper get instance {
    _instance ??= SharedPreferencesHelper._();
    return _instance!;
  }

  Future<void> initPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  bool isPokemonFavorite(int id) {
    return _pref!.getBool(id.toString()) ?? false;
  }

  void setPokemonFavorite(int id) async {
    if (isPokemonFavorite(id)) {
      _pref!.remove(id.toString());
    } else {
      _pref!.setBool(id.toString(), true);
    }
  }

  List<String> getFavoritesPokemons() {
    return _pref!.getKeys().toList();
  }
}
