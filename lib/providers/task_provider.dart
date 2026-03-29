import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

final taskListProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks();
});

final completedTaskListProvider = StreamProvider<List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchCompletedTasks();
});

bool _todayTaskFilter(Task task) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  if (task.dueDate == null) return false;
  final dueDate = task.dueDate!.toDate();
  return dueDate.isBefore(tomorrow);
}

final todayTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_todayTaskFilter).toList();
  });
});

final completedTodayTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(completedTaskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_todayTaskFilter).toList();
  });
});

bool _todoTaskFilter(Task task) {
  return task.dueDate == null &&
      (task.isLater == null || task.isLater == false);
}

final todoTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_todoTaskFilter).toList();
  });
});

final completedTodoTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(completedTaskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_todoTaskFilter).toList();
  });
});

bool _laterTaskFilter(Task task) {
  return task.dueDate == null && task.isLater == true;
}

final laterTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_laterTaskFilter).toList();
  });
});

final completedLaterTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(completedTaskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_laterTaskFilter).toList();
  });
});

bool _upcomingTaskFilter(Task task) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  if (task.dueDate == null) return false;
  final dueDate = task.dueDate!.toDate();
  return dueDate.isAfter(today);
}

final upcomingTaskListProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final tasksAsync = ref.watch(taskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_upcomingTaskFilter).toList()
      ..sort((a, b) => (a.dueDate!).compareTo(b.dueDate!));
  });
});

final completedUpcomingTaskListProvider = Provider<AsyncValue<List<Task>>>((
  ref,
) {
  final tasksAsync = ref.watch(completedTaskListProvider);

  return tasksAsync.whenData((tasks) {
    return tasks.where(_upcomingTaskFilter).toList();
  });
});
