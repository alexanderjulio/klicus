import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'klicus_favorites';
  Set<String> _ids = {};

  Set<String> get ids => _ids;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _ids = Set<String>.from(prefs.getStringList(_key) ?? []);
    notifyListeners();
  }

  bool isFavorite(String adId) => _ids.contains(adId);

  Future<void> toggle(String adId) async {
    if (_ids.contains(adId)) {
      _ids.remove(adId);
    } else {
      _ids.add(adId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.toList());
  }
}
