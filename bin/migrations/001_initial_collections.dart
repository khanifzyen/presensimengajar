import '../src/models/collection_config.dart';

class InitialCollections {
  static List<CollectionConfig> getCollections() {
    return [
      // Users Collection
      CollectionConfig(
        id: 'users',
        name: 'Users',
        permissions: [
          'read("any")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
        attributes: [
          AttributeConfig(
            key: 'email',
            type: AttributeType.string,
            required: true,
            size: 255,
          ),
          AttributeConfig(
            key: 'name',
            type: AttributeType.string,
            required: true,
            size: 100,
          ),
          AttributeConfig(
            key: 'role',
            type: AttributeType.string,
            required: true,
            size: 20,
            defaultValue: 'teacher',
          ),
          AttributeConfig(
            key: 'phone',
            type: AttributeType.string,
            size: 20,
          ),
          AttributeConfig(
            key: 'photo',
            type: AttributeType.string,
            size: 255,
          ),
          AttributeConfig(
            key: 'isActive',
            type: AttributeType.boolean,
            defaultValue: true,
          ),
          AttributeConfig(
            key: 'attendanceCategory',
            type: AttributeType.string,
            size: 20,
            defaultValue: 'teaching',
          ),
          AttributeConfig(
            key: 'createdAt',
            type: AttributeType.datetime,
            required: true,
          ),
          AttributeConfig(
            key: 'updatedAt',
            type: AttributeType.datetime,
            required: true,
          ),
        ],
        indexes: [
          IndexConfig(
            key: 'email_unique',
            type: 'unique',
            attributes: ['email'],
          ),
          IndexConfig(
            key: 'role_index',
            type: 'key',
            attributes: ['role'],
          ),
        ],
      ),

      // Schedules Collection
      CollectionConfig(
        id: 'schedules',
        name: 'Schedules',
        permissions: [
          'read("any")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
        attributes: [
          AttributeConfig(
            key: 'teacherId',
            type: AttributeType.string,
            required: true,
            size: 255,
          ),
          AttributeConfig(
            key: 'title',
            type: AttributeType.string,
            required: true,
            size: 100,
          ),
          AttributeConfig(
            key: 'dayOfWeek',
            type: AttributeType.integer,
            required: true,
            min: 1,
            max: 7,
          ),
          AttributeConfig(
            key: 'startTime',
            type: AttributeType.string,
            required: true,
            size: 5,
          ),
          AttributeConfig(
            key: 'endTime',
            type: AttributeType.string,
            required: true,
            size: 5,
          ),
          AttributeConfig(
            key: 'location',
            type: AttributeType.string,
            required: true,
            size: 255,
          ),
          AttributeConfig(
            key: 'latitude',
            type: AttributeType.double,
            required: true,
          ),
          AttributeConfig(
            key: 'longitude',
            type: AttributeType.double,
            required: true,
          ),
          AttributeConfig(
            key: 'radius',
            type: AttributeType.integer,
            required: true,
            defaultValue: 500,
          ),
          AttributeConfig(
            key: 'isActive',
            type: AttributeType.boolean,
            defaultValue: true,
          ),
          AttributeConfig(
            key: 'createdAt',
            type: AttributeType.datetime,
            required: true,
          ),
          AttributeConfig(
            key: 'updatedAt',
            type: AttributeType.datetime,
            required: true,
          ),
        ],
        indexes: [
          IndexConfig(
            key: 'teacher_day_index',
            type: 'key',
            attributes: ['teacherId', 'dayOfWeek'],
          ),
          IndexConfig(
            key: 'location_index',
            type: 'key',
            attributes: ['latitude', 'longitude'],
          ),
        ],
      ),

      // Attendance Collection
      CollectionConfig(
        id: 'attendance',
        name: 'Attendance',
        permissions: [
          'read("any")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
        attributes: [
          AttributeConfig(
            key: 'teacherId',
            type: AttributeType.string,
            required: true,
            size: 255,
          ),
          AttributeConfig(
            key: 'scheduleId',
            type: AttributeType.string,
            required: true,
            size: 255,
          ),
          AttributeConfig(
            key: 'type',
            type: AttributeType.string,
            required: true,
            size: 20,
          ),
          AttributeConfig(
            key: 'checkInTime',
            type: AttributeType.datetime,
          ),
          AttributeConfig(
            key: 'checkOutTime',
            type: AttributeType.datetime,
          ),
          AttributeConfig(
            key: 'checkInLocation',
            type: AttributeType.string,
            size: 255,
          ),
          AttributeConfig(
            key: 'checkOutLocation',
            type: AttributeType.string,
            size: 255,
          ),
          AttributeConfig(
            key: 'checkInPhoto',
            type: AttributeType.string,
            size: 255,
          ),
          AttributeConfig(
            key: 'checkOutPhoto',
            type: AttributeType.string,
            size: 255,
          ),
          AttributeConfig(
            key: 'status',
            type: AttributeType.string,
            required: true,
            size: 20,
            defaultValue: 'present',
          ),
          AttributeConfig(
            key: 'notes',
            type: AttributeType.string,
            size: 500,
          ),
          AttributeConfig(
            key: 'isManual',
            type: AttributeType.boolean,
            defaultValue: false,
          ),
          AttributeConfig(
            key: 'createdAt',
            type: AttributeType.datetime,
            required: true,
          ),
          AttributeConfig(
            key: 'updatedAt',
            type: AttributeType.datetime,
            required: true,
          ),
        ],
        indexes: [
          IndexConfig(
            key: 'teacher_date_index',
            type: 'key',
            attributes: ['teacherId', 'createdAt'],
          ),
          IndexConfig(
            key: 'schedule_index',
            type: 'key',
            attributes: ['scheduleId'],
          ),
          IndexConfig(
            key: 'status_index',
            type: 'key',
            attributes: ['status'],
          ),
        ],
      ),

      // Settings Collection
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
            key: 'key',
            type: AttributeType.string,
            required: true,
            size: 100,
          ),
          AttributeConfig(
            key: 'value',
            type: AttributeType.string,
            required: true,
            size: 1000,
          ),
          AttributeConfig(
            key: 'description',
            type: AttributeType.string,
            size: 500,
          ),
          AttributeConfig(
            key: 'type',
            type: AttributeType.string,
            required: true,
            size: 20,
            defaultValue: 'string',
          ),
          AttributeConfig(
            key: 'updatedAt',
            type: AttributeType.datetime,
            required: true,
          ),
        ],
        indexes: [
          IndexConfig(
            key: 'key_unique',
            type: 'unique',
            attributes: ['key'],
          ),
        ],
      ),

      // Leave Requests Collection
      CollectionConfig(
        id: 'leave_requests',
        name: 'Leave Requests',
        permissions: [
          'read("any")',
          'create("users")',
          'update("users")',
          'delete("users")',
        ],
        attributes: [
          AttributeConfig(
            key: 'teacherId',
            type: AttributeType.string,
            required: true,
            size: 255,
          ),
          AttributeConfig(
            key: 'type',
            type: AttributeType.string,
            required: true,
            size: 20,
          ),
          AttributeConfig(
            key: 'startDate',
            type: AttributeType.datetime,
            required: true,
          ),
          AttributeConfig(
            key: 'endDate',
            type: AttributeType.datetime,
            required: true,
          ),
          AttributeConfig(
            key: 'reason',
            type: AttributeType.string,
            required: true,
            size: 500,
          ),
          AttributeConfig(
            key: 'status',
            type: AttributeType.string,
            required: true,
            size: 20,
            defaultValue: 'pending',
          ),
          AttributeConfig(
            key: 'approvedBy',
            type: AttributeType.string,
            size: 255,
          ),
          AttributeConfig(
            key: 'approvedAt',
            type: AttributeType.datetime,
          ),
          AttributeConfig(
            key: 'rejectionReason',
            type: AttributeType.string,
            size: 500,
          ),
          AttributeConfig(
            key: 'createdAt',
            type: AttributeType.datetime,
            required: true,
          ),
          AttributeConfig(
            key: 'updatedAt',
            type: AttributeType.datetime,
            required: true,
          ),
        ],
        indexes: [
          IndexConfig(
            key: 'teacher_status_index',
            type: 'key',
            attributes: ['teacherId', 'status'],
          ),
          IndexConfig(
            key: 'date_index',
            type: 'key',
            attributes: ['startDate', 'endDate'],
          ),
        ],
      ),
    ];
  }
}