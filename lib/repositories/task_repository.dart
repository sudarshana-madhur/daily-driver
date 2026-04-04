import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  return TaskRepository(
    FirebaseFirestore.instance,
    user?.uid ?? 'unauthenticated',
  );
});

class TaskRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  TaskRepository(this._firestore, this._userId);

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('users').doc(_userId).collection('tasks');

  String generateTaskId() => _tasks.doc().id;

  Stream<List<Task>> watchTasks() {
    return _tasks
        .where('status', isNotEqualTo: TaskStatus.completed.name)
        .orderBy('position')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Task>> watchCompletedTasks() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    return _tasks
        .where('status', isEqualTo: TaskStatus.completed.name)
        .where('completedAt', isGreaterThanOrEqualTo: startOfToday)
        .where('completedAt', isLessThan: startOfTomorrow)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> createTask(Task task) async {
    await _tasks.doc(task.id).set(task.toMap());
  }

  Future<void> updateTaskStatus(Task task, TaskStatus status) async {
    final updateData = <String, dynamic>{'status': status.name};

    if (status == TaskStatus.inProgress) {
      updateData['inProgressAt'] = FieldValue.serverTimestamp();
    } else if (status == TaskStatus.completed) {
      updateData['completedAt'] = FieldValue.serverTimestamp();
      updateData['isRecurrenceCreated'] = true;

      // Fire and forget asynchronous call
      checkRecurringTasks(task);
    }

    await _tasks.doc(task.id).update(updateData);
  }

  Future<void> updateTask(Task task) async {
    await _tasks.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }

  Future<void> checkRecurringTasks(Task task) async {
    if (task.isRecurring &&
        task.dueDate != null &&
        task.recurrenceInterval != null &&
        task.isRecurrenceCreated != true) {
      final newDueDate = _calculateNextDueDate(
        task.dueDate!.toDate(),
        task.recurrenceInterval!,
        task.customRecurrenceDays,
      );

      final newTask = task.copyWith(
        id: generateTaskId(),
        status: TaskStatus.todo,
        dueDate: Timestamp.fromDate(newDueDate),
        createdAt: Timestamp.now(),
        inProgressAt: null,
        completedAt: null,
      );

      await createTask(newTask);
    }
  }

  DateTime _calculateNextDueDate(
    DateTime currentDueDate,
    String interval,
    int? customRecurrenceDays,
  ) {
    final intervalLower = interval.toLowerCase();
    if (intervalLower == 'daily') {
      return currentDueDate.add(const Duration(days: 1));
    } else if (intervalLower == 'weekly') {
      return currentDueDate.add(const Duration(days: 7));
    } else if (intervalLower == 'monthly') {
      // Logic for monthly:
      // Try to keep the same day of the month by shifting the month.
      // If the day doesn't exist in the target month (e.g., Jan 31 -> Feb 31),
      // we shift to the last day of that month (e.g., Feb 28 or 29).
      final int year = currentDueDate.year;
      final int month = currentDueDate.month;
      final int day = currentDueDate.day;

      final int targetMonth = month == 12 ? 1 : month + 1;
      final int targetYear = month == 12 ? year + 1 : year;

      final int daysInTargetMonth = DateTime(
        targetYear,
        targetMonth + 1,
        0,
      ).day;
      final int targetDay = day > daysInTargetMonth ? daysInTargetMonth : day;

      return DateTime(
        targetYear,
        targetMonth,
        targetDay,
        currentDueDate.hour,
        currentDueDate.minute,
        currentDueDate.second,
        currentDueDate.millisecond,
        currentDueDate.microsecond,
      );
    } else if (intervalLower == 'custom' && customRecurrenceDays != null) {
      return currentDueDate.add(Duration(days: customRecurrenceDays));
    }
    return currentDueDate;
  }
}
