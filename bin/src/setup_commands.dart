
import 'package:args/args.dart';
import 'package:logger/logger.dart';
import 'appwrite_service.dart';
import 'migration_manager.dart';
import 'seeder.dart';

class SetupCommands {
  final AppwriteService appwriteService;
  final MigrationManager migrationManager;
  final Seeder seeder;
  final Logger _logger;

  SetupCommands({
    required this.appwriteService,
    required this.migrationManager,
    required this.seeder,
    required Logger logger,
  }) : _logger = logger;

  Future<void> init(ArgResults results) async {
    _logger.i('Initializing Presensi Mengajar database...');

    final force = results['force'] as bool;

    if (force) {
      _logger.w('Force mode enabled - this may overwrite existing data');
    }

    // Check if database exists
    final dbExists = await appwriteService.databaseExists();
    if (!dbExists) {
      await appwriteService.createDatabase();
    } else if (!force) {
      _logger.i('Database already exists. Use --force to overwrite.');
      return;
    }

    // Create storage buckets
    await appwriteService.createBucket('profile_pictures', 'Profile Pictures');
    await appwriteService.createBucket('attendance_photos', 'Attendance Photos');

    // Run migrations
    await migrationManager.runUp(appwriteService);

    _logger.i('Database initialization completed successfully');
  }

  Future<void> migrate(ArgResults results) async {
    _logger.i('Running database migrations...');

    final up = results['up'] as bool;
    final down = results['down'] as bool;

    if (up && down) {
      throw ArgumentError('Cannot specify both --up and --down');
    }

    if (up || (!up && !down)) {
      await migrationManager.runUp(appwriteService);
    } else if (down) {
      await migrationManager.runDown(appwriteService);
    }

    _logger.i('Migrations completed successfully');
  }

  Future<void> seed(ArgResults results) async {
    _logger.i('Seeding database...');

    final environment = results['environment'] as String;
    final refresh = results['refresh'] as bool;

    if (refresh) {
      _logger.w('Refresh mode enabled - existing data will be cleared');
    }

    switch (environment) {
      case 'dev':
        await seeder.seedDev(appwriteService);
        break;
      case 'prod':
        await seeder.seedProd(appwriteService);
        break;
      case 'staging':
        await seeder.seedDev(appwriteService); // Use dev data for staging
        break;
      default:
        throw ArgumentError('Invalid environment: $environment');
    }

    _logger.i('Database seeding completed successfully');
  }

  Future<void> validate() async {
    _logger.i('Validating database schema...');

    final dbExists = await appwriteService.databaseExists();
    if (!dbExists) {
      throw Exception('Database does not exist. Run init first.');
    }

    // Check required collections
    final requiredCollections = [
      'users',
      'teachers',
      'attendance',
      'schedules',
      'settings',
    ];

    for (var collectionId in requiredCollections) {
      final exists = await appwriteService.collectionExists(collectionId);
      if (!exists) {
        throw Exception('Required collection $collectionId does not exist');
      }
    }

    _logger.i('Database schema validation passed');
  }

  Future<void> status() async {
    _logger.i('Database Status:');

    final dbExists = await appwriteService.databaseExists();
    _logger.i('Database: ${dbExists ? '✅ Exists' : '❌ Not found'}');

    if (dbExists) {
      final collections = ['users', 'teachers', 'attendance', 'schedules', 'settings'];

      for (var collectionId in collections) {
        final exists = await appwriteService.collectionExists(collectionId);
        _logger.i('$collectionId: ${exists ? '✅' : '❌'}');
      }

      final migrations = await migrationManager.getMigrations();
      _logger.i('Migrations found: ${migrations.length}');
    }
  }

  Future<void> createMigration(ArgResults results) async {
    final version = results['version'] as String;
    final description = results['description'] as String;

    await migrationManager.createMigration(version, description);
    _logger.i('Migration $version created successfully');
  }
}