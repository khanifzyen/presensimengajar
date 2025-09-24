

enum AttributeType {
  string,
  integer,
  boolean,
  datetime,
  double,
}

class CollectionConfig {
  final String id;
  final String name;
  final List<AttributeConfig> attributes;
  final List<IndexConfig> indexes;
  final List<String> permissions;

  CollectionConfig({
    required this.id,
    required this.name,
    required this.attributes,
    required this.indexes,
    required this.permissions,
  });
}

class AttributeConfig {
  final String key;
  final AttributeType type;
  final bool required;
  final bool array;
  final int? size;
  final dynamic defaultValue;
  final num? min;
  final num? max;

  AttributeConfig({
    required this.key,
    required this.type,
    this.required = false,
    this.array = false,
    this.size,
    this.defaultValue,
    this.min,
    this.max,
  });
}

class IndexConfig {
  final String key;
  final String type; // 'key', 'fulltext', 'unique'
  final List<String> attributes;
  final List<String>? orders;

  IndexConfig({
    required this.key,
    required this.type,
    required this.attributes,
    this.orders,
  });
}