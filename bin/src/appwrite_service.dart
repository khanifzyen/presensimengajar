import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:dart_appwrite/enums.dart' as enums;
import 'package:dotenv/dotenv.dart';
import 'package:logger/logger.dart';
import 'models/collection_config.dart';

class AppwriteService {
  final DotEnv _env;
  final Logger _logger;
  late final appwrite.Client _client;
  late final appwrite.Databases _databases;
  late final appwrite.Storage _storage;

  AppwriteService(this._env, this._logger) {
    _validateEnvironment();
    _initializeClient();
  }

  void _validateEnvironment() {
    final required = [
      'APPWRITE_ENDPOINT',
      'APPWRITE_PROJECT_ID',
      'APPWRITE_API_KEY',
      'APPWRITE_DATABASE_ID'
    ];

    for (var key in required) {
      if (_env[key] == null || _env[key]!.isEmpty) {
        throw Exception('Required environment variable $key is not set');
      }
    }
  }

  void _initializeClient() {
    _client = appwrite.Client()
      .setEndpoint(_env['APPWRITE_ENDPOINT']!)
      .setProject(_env['APPWRITE_PROJECT_ID']!)
      .setKey(_env['APPWRITE_API_KEY']!);

    _databases = appwrite.Databases(_client);
    _storage = appwrite.Storage(_client);
  }

  Future<bool> databaseExists() async {
    try {
      await _databases.get(
        databaseId: _env['APPWRITE_DATABASE_ID']!,
      );
      return true;
    } on appwrite.AppwriteException catch (e) {
      if (e.code == 404) return false;
      rethrow;
    }
  }

  Future<void> createDatabase() async {
    _logger.i('Creating database...');

    try {
      await _databases.create(
        databaseId: _env['APPWRITE_DATABASE_ID']!,
        name: 'Presensi Mengajar Database',
      );
      _logger.i('Database created successfully');
    } on appwrite.AppwriteException catch (e) {
      if (e.code != 409) { // Already exists
        rethrow;
      }
      _logger.w('Database already exists');
    }
  }

  Future<bool> collectionExists(String collectionId) async {
    try {
      await _databases.getCollection(
        databaseId: _env['APPWRITE_DATABASE_ID']!,
        collectionId: collectionId,
      );
      return true;
    } on appwrite.AppwriteException catch (e) {
      if (e.code == 404) return false;
      rethrow;
    }
  }

  Future<void> createCollection(CollectionConfig config) async {
    _logger.i('Creating collection: ${config.id}');

    try {
      await _databases.createCollection(
        databaseId: _env['APPWRITE_DATABASE_ID']!,
        collectionId: config.id,
        name: config.name,
        permissions: config.permissions,
        documentSecurity: true,
      );

      // Create attributes
      for (var attr in config.attributes) {
        await _createAttribute(config.id, attr);
      }

      // Create indexes
      for (var index in config.indexes) {
        await _createIndex(config.id, index);
      }

      _logger.i('Collection ${config.id} created successfully');
    } on appwrite.AppwriteException catch (e) {
      if (e.code != 409) { // Already exists
        rethrow;
      }
      _logger.w('Collection ${config.id} already exists');
    }
  }

  Future<void> _createAttribute(String collectionId, AttributeConfig attr) async {
    switch (attr.type) {
      case AttributeType.string:
        await _databases.createStringAttribute(
          databaseId: _env['APPWRITE_DATABASE_ID']!,
          collectionId: collectionId,
          key: attr.key,
          size: attr.size ?? 255,
          xrequired: attr.required,
          xdefault: attr.defaultValue,
          array: attr.array,
        );
        break;
      case AttributeType.integer:
        await _databases.createIntegerAttribute(
          databaseId: _env['APPWRITE_DATABASE_ID']!,
          collectionId: collectionId,
          key: attr.key,
          xrequired: attr.required,
          xdefault: attr.defaultValue,
          array: attr.array,
          min: attr.min?.toInt(),
          max: attr.max?.toInt(),
        );
        break;
      case AttributeType.boolean:
        await _databases.createBooleanAttribute(
          databaseId: _env['APPWRITE_DATABASE_ID']!,
          collectionId: collectionId,
          key: attr.key,
          xrequired: attr.required,
          xdefault: attr.defaultValue,
          array: attr.array,
        );
        break;
      case AttributeType.datetime:
        await _databases.createDatetimeAttribute(
          databaseId: _env['APPWRITE_DATABASE_ID']!,
          collectionId: collectionId,
          key: attr.key,
          xrequired: attr.required,
          xdefault: attr.defaultValue,
          array: attr.array,
        );
        break;
      case AttributeType.double:
        await _databases.createFloatAttribute(
          databaseId: _env['APPWRITE_DATABASE_ID']!,
          collectionId: collectionId,
          key: attr.key,
          xrequired: attr.required,
          xdefault: attr.defaultValue,
          array: attr.array,
          min: attr.min?.toDouble(),
          max: attr.max?.toDouble(),
        );
        break;
    }
  }

  Future<void> _createIndex(String collectionId, IndexConfig index) async {
    await _databases.createIndex(
      databaseId: _env['APPWRITE_DATABASE_ID']!,
      collectionId: collectionId,
      key: index.key,
      type: _getIndexTypeEnum(index.type),
      attributes: index.attributes,
      orders: index.orders,
    );
  }

  enums.IndexType _getIndexTypeEnum(String type) {
    switch (type) {
      case 'key':
        return enums.IndexType.key;
      case 'fulltext':
        return enums.IndexType.fulltext;
      case 'unique':
        return enums.IndexType.unique;
      case 'spatial':
        return enums.IndexType.spatial;
      default:
        return enums.IndexType.key;
    }
  }

  Future<void> createBucket(String bucketId, String name) async {
    _logger.i('Creating bucket: $bucketId');

    try {
      await _storage.createBucket(
        bucketId: bucketId,
        name: name,
        permissions: [
          appwrite.Permission.read(appwrite.Role.any()),
          appwrite.Permission.create(appwrite.Role.users()),
          appwrite.Permission.update(appwrite.Role.users()),
          appwrite.Permission.delete(appwrite.Role.users()),
        ],
        fileSecurity: true,
      );
      _logger.i('Bucket $bucketId created successfully');
    } on appwrite.AppwriteException catch (e) {
      if (e.code != 409) { // Already exists
        rethrow;
      }
      _logger.w('Bucket $bucketId already exists');
    }
  }

  String get databaseId => _env['APPWRITE_DATABASE_ID']!;

  appwrite.Databases get databases => _databases;
}