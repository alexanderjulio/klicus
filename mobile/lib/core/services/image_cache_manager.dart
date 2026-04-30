import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class KlicusCacheManager {
  static const _key = 'klicusImageCache';

  static final instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: _key),
      fileService: HttpFileService(),
    ),
  );
}
