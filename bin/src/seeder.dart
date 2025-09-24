import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:dotenv/dotenv.dart';
import 'package:logger/logger.dart';
import 'appwrite_service.dart';
import '../seeds/dev_seeds.dart';
import '../seeds/prod_seeds.dart';

class Seeder {
  final Logger _logger;

  Seeder(DotEnv env, this._logger);

  Future<void> seedDev(AppwriteService appwriteService) async {
    _logger.i('Seeding development data...');

    await _seedSettings(appwriteService, DevSeeds.getSettings());
    await _seedUsers(appwriteService, DevSeeds.getSampleUsers());
    await _seedSchedules(appwriteService, DevSeeds.getSampleSchedules());

    _logger.i('Development data seeded successfully');
  }

  Future<void> seedProd(AppwriteService appwriteService) async {
    _logger.i('Seeding production data...');

    // Only seed essential data for production
    await _seedSettings(appwriteService, ProdSeeds.getSettings());
    await _seedUsers(appwriteService, ProdSeeds.getAdminAccount());

    _logger.i('Production data seeded successfully');
  }

  Future<void> _seedSettings(AppwriteService appwriteService, Map<String, dynamic> settingsData) async {
    _logger.i('Seeding settings...');

    final documents = settingsData['documents'] as List;
    for (var doc in documents) {
      await _createDocument(
        appwriteService: appwriteService,
        collectionId: 'settings',
        data: doc,
      );
    }
  }

  Future<void> _seedUsers(AppwriteService appwriteService, Map<String, dynamic> usersData) async {
    _logger.i('Seeding users...');

    final documents = usersData['documents'] as List;
    for (var doc in documents) {
      await _createDocument(
        appwriteService: appwriteService,
        collectionId: 'users',
        data: doc,
      );
    }
  }

  Future<void> _seedSchedules(AppwriteService appwriteService, Map<String, dynamic> schedulesData) async {
    _logger.i('Seeding schedules...');

    final documents = schedulesData['documents'] as List;
    for (var doc in documents) {
      await _createDocument(
        appwriteService: appwriteService,
        collectionId: 'schedules',
        data: doc,
      );
    }
  }

  Future<void> _createDocument({
    required AppwriteService appwriteService,
    required String collectionId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await appwriteService.databases.createDocument(
        databaseId: appwriteService.databaseId,
        collectionId: collectionId,
        documentId: appwrite.ID.unique(),
        data: data,
      );
      _logger.i('Document created in $collectionId');
    } on appwrite.AppwriteException catch (e) {
      _logger.w('Document creation failed in $collectionId: ${e.message}');
    }
  }
}