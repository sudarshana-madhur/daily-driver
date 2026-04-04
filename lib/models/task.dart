import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { todo, inProgress, completed }

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
    String? label,
    Timestamp? dueDate,
    Timestamp? createdAt,
    Timestamp? inProgressAt,
    Timestamp? completedAt,
    bool? isRecurring,
    String? recurrenceInterval,
    double? position,
    bool? isLater,
    bool? isRecurrenceCreated,
    int? customRecurrenceDays,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      label: label ?? this.label,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      inProgressAt: inProgressAt ?? this.inProgressAt,
      completedAt: completedAt ?? this.completedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      position: position ?? this.position,
      isLater: isLater ?? this.isLater,
      isRecurrenceCreated: isRecurrenceCreated ?? this.isRecurrenceCreated,
      customRecurrenceDays: customRecurrenceDays ?? this.customRecurrenceDays,
    );
  }
}
