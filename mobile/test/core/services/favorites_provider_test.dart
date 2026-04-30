import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:klicus_mobile/core/services/favorites_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('FavoritesProvider — toggle', () {
    test('toggle adds id when not favorited', () async {
      final provider = FavoritesProvider();
      await provider.load();

      await provider.toggle('ad_123');

      expect(provider.isFavorite('ad_123'), isTrue);
    });

    test('toggle removes id when already favorited', () async {
      final provider = FavoritesProvider();
      await provider.load();

      await provider.toggle('ad_123');
      await provider.toggle('ad_123');

      expect(provider.isFavorite('ad_123'), isFalse);
    });

    test('ids set reflects toggled state', () async {
      final provider = FavoritesProvider();
      await provider.load();

      await provider.toggle('ad_1');
      await provider.toggle('ad_2');

      expect(provider.ids.length, equals(2));
      expect(provider.ids, containsAll(['ad_1', 'ad_2']));
    });

    test('notifyListeners called on toggle', () async {
      final provider = FavoritesProvider();
      await provider.load();
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.toggle('ad_999');

      expect(notifyCount, greaterThan(0));
    });
  });

  group('FavoritesProvider — persistence', () {
    test('toggle persists to SharedPreferences', () async {
      final p1 = FavoritesProvider();
      await p1.load();
      await p1.toggle('ad_456');

      final p2 = FavoritesProvider();
      await p2.load();

      expect(p2.isFavorite('ad_456'), isTrue);
    });

    test('load restores previously saved favorites', () async {
      SharedPreferences.setMockInitialValues({
        'klicus_favorites': ['ad_1', 'ad_2', 'ad_3'],
      });

      final provider = FavoritesProvider();
      await provider.load();

      expect(provider.ids.length, equals(3));
      expect(provider.isFavorite('ad_1'), isTrue);
      expect(provider.isFavorite('ad_3'), isTrue);
    });

    test('untoggled id not in ids after load', () async {
      final provider = FavoritesProvider();
      await provider.load();

      expect(provider.isFavorite('nonexistent'), isFalse);
    });

    test('remove via second toggle is persisted', () async {
      final p1 = FavoritesProvider();
      await p1.load();
      await p1.toggle('ad_777');
      await p1.toggle('ad_777'); // remove

      final p2 = FavoritesProvider();
      await p2.load();

      expect(p2.isFavorite('ad_777'), isFalse);
    });
  });
}
