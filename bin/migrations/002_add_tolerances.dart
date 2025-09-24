import '../src/models/collection_config.dart';

class AddTolerances {
  static List<CollectionConfig> getUpdates() {
    return [
      // Update Settings Collection with tolerance values
      CollectionConfig(
        id: 'settings',
        name: 'Settings',
        permissions: [
          'read("any")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
        attributes: [
          AttributeConfig(
            key: 'tolerance_late_arrival',
            type: AttributeType.integer,
            defaultValue: 10,
          ),
          AttributeConfig(
            key: 'tolerance_early_departure',
            type: AttributeType.integer,
            defaultValue: 10,
          ),
          AttributeConfig(
            key: 'mock_location_detection',
            type: AttributeType.boolean,
            defaultValue: true,
          ),
          AttributeConfig(
            key: 'photo_required',
            type: AttributeType.boolean,
            defaultValue: true,
          ),
        ],
        indexes: [],
      ),
    ];
  }
}