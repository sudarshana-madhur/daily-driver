import 'package:daily_driver/widgets/task_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';

class ListViewScreen extends ConsumerWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TaskListView(
      tasksAsync: ref.watch(todayTaskListProvider),
      completedTasksAsync: ref.watch(completedTodayTaskListProvider),
    );
  }
}
