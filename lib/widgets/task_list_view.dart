import 'package:daily_driver/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskListView extends ConsumerWidget {
  final AsyncValue<List<Task>> tasksAsync;
  final AsyncValue<List<Task>> completedTasksAsync;
  final String? screen;

  const TaskListView({
    super.key,
    required this.tasksAsync,
    required this.completedTasksAsync,
    this.screen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool enableSorting = true;
    if (screen == 'upcoming') {
      enableSorting = false;
    }

    void onChanged(Task task, bool value) {
      if (value == true) {
        ref
            .read(taskRepositoryProvider)
            .updateTaskStatus(task, TaskStatus.completed);
      } else if (value == false) {
        ref
            .read(taskRepositoryProvider)
            .updateTaskStatus(task, TaskStatus.todo);
      }
    }

    return tasksAsync.when(
      data: (tasks) {
        return ReorderableListView.builder(
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            if (oldIndex == newIndex) return;

            final List<Task> mutableTasks = List.from(tasks);
            final movedTask = mutableTasks.removeAt(oldIndex);
            mutableTasks.insert(newIndex, movedTask);

            double newPosition;
            if (newIndex == 0) {
              newPosition = mutableTasks[1].position - 100000.0;
            } else if (newIndex == mutableTasks.length - 1) {
              newPosition =
                  mutableTasks[mutableTasks.length - 2].position + 100000.0;
            } else {
              newPosition =
                  (mutableTasks[newIndex - 1].position +
                      mutableTasks[newIndex + 1].position) /
                  2.0;
            }

            ref
                .read(taskRepositoryProvider)
                .updateTask(movedTask.copyWith(position: newPosition));
          },
          itemBuilder: (context, index) {
            final task = tasks[index];

            return ReorderableDelayedDragStartListener(
              enabled: enableSorting,
              key: ValueKey(task.id),
              index: index,
              child: TaskCard(task: task, onChanged: onChanged),
            );
          },
          footer: completedTasksAsync.when(
            data: (completedTasks) {
              if (completedTasks.isEmpty && tasks.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 64.0),
                  child: Center(child: Text('No tasks yet.')),
                );
              }
              if (completedTasks.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  if (tasks.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(height: 1, thickness: 1),
                    ),
                  ...completedTasks.map(
                    (task) => TaskCard(task: task, onChanged: onChanged),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('Error: $err')),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
