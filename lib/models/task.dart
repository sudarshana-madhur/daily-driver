import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { todo, inProgress, completed }

const Object _undefined = Object();

class Task {
  final String id;
  final String title;
  final TaskStatus status;
  final String? label;
  final Timestamp? dueDate;
  final Timestamp createdAt;
  final Timestamp? inProgressAt;
  final Timestamp? completedAt;
  final bool isRecurring;
  final String? recurrenceInterval; // 'Daily', 'Weekly'
  final double position;
  final bool? isLater;
  final bool? isRecurrenceCreated;
  final int? customRecurrenceDays;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.label,
    this.dueDate,
    required this.createdAt,
    this.inProgressAt,
    this.completedAt,
    this.isRecurring = false,
    this.recurrenceInterval,
    this.isLater,
    this.isRecurrenceCreated,
    this.customRecurrenceDays,
    double? position,
  }) : position = position ?? -createdAt.millisecondsSinceEpoch.toDouble();

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'],
      status: TaskStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'todo'),
        orElse: () => TaskStatus.todo,
      ),
      label: map['label'],
      dueDate: map['dueDate'] as Timestamp?,
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      inProgressAt: map['inProgressAt'] as Timestamp?,
      completedAt: map['completedAt'] as Timestamp?,
      isRecurring: map['isRecurring'] ?? false,
      recurrenceInterval: map['recurrenceInterval'],
      position: (map['position'] as num?)?.toDouble(),
      isLater: map['isLater'] ?? false,
      isRecurrenceCreated: map['isRecurrenceCreated'] ?? false,
      customRecurrenceDays: map['customRecurrenceDays'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status.name,
      'label': label,
      'dueDate': dueDate,
      'createdAt': createdAt,
      'inProgressAt': inProgressAt,
      'completedAt': completedAt,
      'isRecurring': isRecurring,
      'recurrenceInterval': recurrenceInterval,
      'position': position,
      'isLater': isLater,
      'isRecurrenceCreated': isRecurrenceCreated,
      'customRecurrenceDays': customRecurrenceDays,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    TaskStatus? status,
    Object? label = _undefined,
    Object? dueDate = _undefined,
    Timestamp? createdAt,
    Object? inProgressAt = _undefined,
    Object? completedAt = _undefined,
    bool? isRecurring,
    Object? recurrenceInterval = _undefined,
    Object? position = _undefined,
    Object? isLater = _undefined,
    Object? isRecurrenceCreated = _undefined,
    Object? customRecurrenceDays = _undefined,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      label: label == _undefined ? this.label : (label as String?),
      dueDate: dueDate == _undefined ? this.dueDate : (dueDate as Timestamp?),
      createdAt: createdAt ?? this.createdAt,
      inProgressAt: inProgressAt == _undefined
          ? this.inProgressAt
          : (inProgressAt as Timestamp?),
      completedAt: completedAt == _undefined
          ? this.completedAt
          : (completedAt as Timestamp?),
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceInterval: recurrenceInterval == _undefined
          ? this.recurrenceInterval
          : (recurrenceInterval as String?),
      position: position == _undefined ? this.position : (position as double?),
      isLater: isLater == _undefined ? this.isLater : (isLater as bool?),
      isRecurrenceCreated: isRecurrenceCreated == _undefined
          ? this.isRecurrenceCreated
          : (isRecurrenceCreated as bool?),
      customRecurrenceDays: customRecurrenceDays == _undefined
          ? this.customRecurrenceDays
          : (customRecurrenceDays as int?),
    );
  }
}
