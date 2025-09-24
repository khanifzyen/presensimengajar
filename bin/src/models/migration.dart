
import 'collection_config.dart';

class Migration {
  final String version;
  final String description;
  final DateTime createdAt;
  final List<CollectionConfig> collections;
  final List<String> up;
  final List<String> down;

  Migration({
    required this.version,
    required this.description,
    required this.collections,
    required this.up,
    required this.down,
  }) : createdAt = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'collections': collections.map((c) => c.id).toList(),
      'up': up,
      'down': down,
    };
  }
}