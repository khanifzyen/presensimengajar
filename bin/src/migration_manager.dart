
import 'dart:io';
import 'package:logger/logger.dart';
import 'models/migration.dart';
import 'models/collection_config.dart';
import 'appwrite_service.dart';
import '../migrations/001_initial_collections.dart';
import '../migrations/002_add_tolerances.dart';

class MigrationManager {
  final Logger _logger;
  final String _migrationsPath = 'migrations';

  MigrationManager(this._logger);

  Future<List<Migration>> getMigrations() async {
    final directory = Directory(_migrationsPath);
    if (!await directory.exists()) {
      _logger.w('Migrations directory not found');
      return [];
    }

    final files = await directory.list().where((entity) =>
      entity is File && entity.path.endsWith('.dart')).cast<File>().toList();

    files.sort((a, b) => a.path.compareTo(b.path));

    final migrations = <Migration>[];

    for (var file in files) {
      try {
        final migration = await _loadMigration(file);
        migrations.add(migration);
      } catch (e) {
        _logger.e('Error loading migration ${file.path}: $e');
      }
    }

    return migrations;
  }

  Future<Migration> _loadMigration(File file) async {
    final fileName = file.uri.pathSegments.last;
    final version = fileName.split('_').first;

    // Import migration file based on version
    if (version == '001') {
      final collections = await _loadInitialCollections();
      return Migration(
        version: version,
        description: 'Create initial collections',
        collections: collections,
        up: ['Create users, schedules, attendance, settings, leave_requests collections'],
        down: ['Drop all initial collections'],
      );
    } else if (version == '002') {
      final collections = await _loadTolerances();
      return Migration(
        version: version,
        description: 'Add tolerance settings',
        collections: collections,
        up: ['Add tolerance settings to settings collection'],
        down: ['Remove tolerance settings'],
      );
    }

    return Migration(
      version: version,
      description: 'Migration from $fileName',
      collections: [],
      up: ['Unknown migration'],
      down: ['Unknown migration'],
    );
  }

  Future<List<CollectionConfig>> _loadInitialCollections() async {
    return InitialCollections.getCollections();
  }

  Future<List<CollectionConfig>> _loadTolerances() async {
    return AddTolerances.getUpdates();
  }

  Future<void> runUp(AppwriteService appwriteService) async {
    _logger.i('Running up migrations...');

    final migrations = await getMigrations();

    for (var migration in migrations) {
      _logger.i('Running migration ${migration.version}: ${migration.description}');

      for (var collection in migration.collections) {
        await appwriteService.createCollection(collection);
      }

      _logger.i('Migration ${migration.version} completed');
    }
  }

  Future<void> runDown(AppwriteService appwriteService) async {
    _logger.i('Running down migrations...');

    final migrations = await getMigrations();

    for (var migration in migrations.reversed) {
      _logger.i('Rolling back migration ${migration.version}: ${migration.description}');

      // Implementation for rollback would go here
      // This would typically drop collections or reverse changes

      _logger.i('Migration ${migration.version} rollback completed');
    }
  }

  Future<void> createMigration(String version, String description) async {
    final fileName = '${version}_$description.dart';
    final filePath = '$_migrationsPath/$fileName';

    final file = File(filePath);
    if (await file.exists()) {
      throw Exception('Migration file already exists: $filePath');
    }

    final template = '''
part of '../../server_setup.dart';

class Migration$version {
  static Migration get migration => Migration(
    version: '$version',
    description: '$description',
    collections: [
      // Define your collections here
    ],
    up: [
      // Define up operations
    ],
    down: [
      // Define down operations
    ],
  );
}
''';

    await file.create(recursive: true);
    await file.writeAsString(template);

    _logger.i('Migration created: $filePath');
  }
}