import 'package:flutter_test/flutter_test.dart';
import 'package:klicus_mobile/features/notifications/notification_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationProvider provider;

  setUp(() {
    provider = NotificationProvider();
  });

  tearDown(() {
    provider.dispose();
  });

  group('NotificationProvider — backoff intervals', () {
    test('initial interval is 10 seconds', () {
      expect(provider.currentIntervalForTest, equals(const Duration(seconds: 10)));
    });

    test('single error doubles interval to 20 seconds', () {
      provider.onErrorForTest();

      expect(provider.currentIntervalForTest, equals(const Duration(seconds: 20)));
    });

    test('two errors doubles twice to 40 seconds', () {
      provider.onErrorForTest();
      provider.onErrorForTest();

      expect(provider.currentIntervalForTest, equals(const Duration(seconds: 40)));
    });

    test('errors cap at 5 minutes', () {
      for (int i = 0; i < 10; i++) {
        provider.onErrorForTest();
      }

      expect(provider.currentIntervalForTest, equals(const Duration(minutes: 5)));
    });

    test('interval never exceeds 5 minutes regardless of error count', () {
      for (int i = 0; i < 50; i++) {
        provider.onErrorForTest();
      }

      expect(
        provider.currentIntervalForTest,
        lessThanOrEqualTo(const Duration(minutes: 5)),
      );
    });

    test('success after errors resets to 10 seconds', () {
      provider.onErrorForTest();
      provider.onErrorForTest();
      provider.onErrorForTest();

      provider.onSuccessForTest();

      expect(provider.currentIntervalForTest, equals(const Duration(seconds: 10)));
    });

    test('success after cap resets to 10 seconds', () {
      for (int i = 0; i < 10; i++) {
        provider.onErrorForTest();
      }
      provider.onSuccessForTest();

      expect(provider.currentIntervalForTest, equals(const Duration(seconds: 10)));
    });

    test('multiple success calls keep interval at minimum', () {
      provider.onSuccessForTest();
      provider.onSuccessForTest();

      expect(provider.currentIntervalForTest, equals(const Duration(seconds: 10)));
    });
  });

  group('NotificationProvider — initial state', () {
    test('starts with empty notifications', () {
      expect(provider.notifications, isEmpty);
    });

    test('starts with zero unread count', () {
      expect(provider.unreadCount, equals(0));
    });

    test('starts with isLoading false', () {
      expect(provider.isLoading, isFalse);
    });
  });
}
