#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart';
import 'package:logger/logger.dart';

import 'src/setup_commands.dart';
import 'src/appwrite_service.dart';
import 'src/migration_manager.dart';
import 'src/seeder.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show usage information')
    ..addOption('env', defaultsTo: 'dev', help: 'Environment (dev/staging/prod)')
    ..addOption('config', defaultsTo: '.env', help: 'Environment config file')
    ..addCommand('init', ArgParser()..addFlag('force', help: 'Force overwrite existing data'))
    ..addCommand('migrate', ArgParser()
      ..addFlag('up', help: 'Run migrations up')
      ..addFlag('down', help: 'Run migrations down')
      ..addOption('version', help: 'Specific version to migrate to'))
    ..addCommand('seed', ArgParser()
      ..addOption('environment', defaultsTo: 'dev', help: 'Environment to seed')
      ..addFlag('refresh', help: 'Clear existing data before seeding'))
    ..addCommand('validate', ArgParser())
    ..addCommand('status', ArgParser());

  final results = parser.parse(args);

// Load environment
final env = DotEnv(includePlatformEnvironment: true)..load([results['config']]);

// Setup logger
final logger = Logger(
  printer: PrettyPrinter(),
  level: results['env'] == 'prod' ? Level.info : Level.debug,
);

try {

    if (results['help'] || results.command == null) {
      _showUsage(parser, logger);
      return;
    }

    final commands = SetupCommands(
      appwriteService: AppwriteService(env, logger),
      migrationManager: MigrationManager(logger),
      seeder: Seeder(env, logger),
      logger: logger,
    );

    switch (results.command?.name) {
      case 'init':
        await commands.init(results.command!);
        break;
      case 'migrate':
        await commands.migrate(results.command!);
        break;
      case 'seed':
        await commands.seed(results.command!);
        break;
      case 'validate':
        await commands.validate();
        break;
      case 'status':
        await commands.status();
        break;
      default:
        _showUsage(parser, logger);
    }

    logger.i('Server setup completed successfully');
    exit(0);
  } catch (e, stackTrace) {
    logger.e('Server setup failed', error: e, stackTrace: stackTrace);
    exit(1);
  }
}

void _showUsage(ArgParser parser, Logger logger) {
  logger.i('''
Presensi Mengajar Server Setup Tool

Usage: dart bin/server_setup.dart <command> [options]

Commands:
  init                 Initialize database and collections
  migrate              Run database migrations
  seed                 Seed database with sample data
  validate             Validate database schema
  status               Show current database status

Options:
  --env, -e            Environment (dev/staging/prod) [default: dev]
  --config, -c         Environment config file [default: .env]
  --help, -h           Show this help message

Examples:
  dart bin/server_setup.dart init
  dart bin/server_setup.dart migrate --env prod
  dart bin/server_setup.dart seed --environment dev
  dart bin/server_setup.dart validate
''');
}