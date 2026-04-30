import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:klicus_mobile/features/auth/auth_provider.dart';
import 'package:klicus_mobile/core/api_service.dart';
import 'package:klicus_mobile/core/services/stats_provider.dart';
import 'package:klicus_mobile/features/profile/profile_provider.dart';

/// Stub that bypasses real HTTP, FlutterSecureStorage, and Firebase
class StubApiService extends ApiService {
  Map<String, dynamic> loginResponseData = {
    'token': 'test-token-123',
    'user': {'id': '1', 'name': 'Test User', 'email': 'test@klicus.com'},
  };
  bool shouldThrow = false;

  @override
  Future<Response> post(String path, {dynamic data}) async {
    if (shouldThrow) throw Exception('Network error');
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: loginResponseData,
    );
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    if (path == '/auth/me') {
      return Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
        data: {'user': loginResponseData['user']},
      );
    }
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
      data: {'success': true, 'stats': {}},
    );
  }

  @override
  Future<void> saveToken(String token) async {}
  @override
  Future<void> saveUserData(Map<String, dynamic> user) async {}
  @override
  Future<String?> getStoredToken() async => null;
  @override
  Future<Map<String, dynamic>?> getUserData() async => null;
  @override
  Future<void> logout() async {}
}

AuthProvider _buildProvider(StubApiService api) {
  final stats = StatsProvider(api);
  final profile = ProfileProvider(api);
  return AuthProvider(
    apiService: api,
    statsProvider: stats,
    profileProvider: profile,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StubApiService api;
  late AuthProvider provider;

  setUp(() {
    api = StubApiService();
    provider = _buildProvider(api);
  });

  group('AuthProvider — login', () {
    test('successful login sets isAuthenticated = true', () async {
      final result = await provider.login('test@klicus.com', 'password');

      expect(result, isTrue);
      expect(provider.isAuthenticated, isTrue);
    });

    test('successful login populates currentUser', () async {
      await provider.login('test@klicus.com', 'password');

      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser!['name'], equals('Test User'));
      expect(provider.currentUser!['email'], equals('test@klicus.com'));
    });

    test('successful login clears isLoading', () async {
      await provider.login('test@klicus.com', 'password');

      expect(provider.isLoading, isFalse);
    });

    test('successful login clears error', () async {
      await provider.login('test@klicus.com', 'password');

      expect(provider.error, isNull);
    });

    test('failed login returns false', () async {
      api.shouldThrow = true;

      final result = await provider.login('bad@bad.com', 'wrong');

      expect(result, isFalse);
    });

    test('failed login sets isAuthenticated = false', () async {
      api.shouldThrow = true;

      await provider.login('bad@bad.com', 'wrong');

      expect(provider.isAuthenticated, isFalse);
    });

    test('failed login sets error message', () async {
      api.shouldThrow = true;

      await provider.login('bad@bad.com', 'wrong');

      expect(provider.error, isNotNull);
      expect(provider.error, isNotEmpty);
    });

    test('isLoading transitions true then false during login', () async {
      final states = <bool>[];
      provider.addListener(() => states.add(provider.isLoading));

      await provider.login('test@klicus.com', 'password');

      expect(states, contains(true));
      expect(states.last, isFalse);
    });
  });

  group('AuthProvider — logout', () {
    test('logout clears isAuthenticated', () async {
      await provider.login('test@klicus.com', 'password');
      expect(provider.isAuthenticated, isTrue);

      await provider.logout();

      expect(provider.isAuthenticated, isFalse);
    });

    test('logout clears currentUser', () async {
      await provider.login('test@klicus.com', 'password');
      await provider.logout();

      expect(provider.currentUser, isNull);
    });

    test('logout clears dashboardStats', () async {
      await provider.login('test@klicus.com', 'password');
      await provider.logout();

      expect(provider.dashboardStats, isNull);
    });

    test('logout notifies listeners', () async {
      await provider.login('test@klicus.com', 'password');
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.logout();

      expect(notifyCount, greaterThan(0));
    });
  });

  group('AuthProvider — delegation', () {
    test('dashboardStats delegates to StatsProvider', () async {
      expect(provider.dashboardStats, isNull);
    });

    test('updateCurrentUser syncs currentUser', () {
      provider.updateCurrentUser({'id': '99', 'name': 'Updated'});

      expect(provider.currentUser!['name'], equals('Updated'));
    });
  });
}
