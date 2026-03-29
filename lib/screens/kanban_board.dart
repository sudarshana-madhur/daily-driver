import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class KanbanBoard extends ConsumerWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);

    return tasksAsync.when(
      data: (tasks) {
        final todoTasks = tasks
            .where((t) => t.status == TaskStatus.todo)
            .toList();
        final inProgressTasks = tasks
            .where((t) => t.status == TaskStatus.inProgress)
            .toList();
        final completedTasks = tasks
            .where((t) => t.status == TaskStatus.completed)
            .toList();
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                  maxHeight: constraints.maxHeight - 32,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLane(
                      context,
                      ref,
                      'To-Do',
                      TaskStatus.todo,
                      todoTasks,
                    ),
                    const SizedBox(width: 16),
                    _buildLane(
                      context,
                      ref,
                      'In-Progress',
                      TaskStatus.inProgress,
                      inProgressTasks,
                    ),
                    const SizedBox(width: 16),
                    _buildLane(
                      context,
                      ref,
                      'Completed',
                      TaskStatus.completed,
                      completedTasks,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildLane(
    BuildContext context,
    WidgetRef ref,
    String title,
    TaskStatus status,
    List<Task> tasks,
  ) {
    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) => details.data.status != status,
      onAcceptWithDetails: (details) {
        ref.read(taskRepositoryProvider).updateTaskStatus(details.data, status);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 300,
          decoration: BoxDecoration(
            // color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(candidateData.isNotEmpty ? 0.8 : 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title (${tasks.length})',
                // style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) =>
                      _buildKanbanCard(context, tasks[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKanbanCard(BuildContext context, Task task) {
    final card = Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (task.isRecurring)
                  Icon(
                    Icons.repeat,
                    size: 14,
                    //  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)
                  ),
                const Spacer(),
                // Text(
                //   task.label,
                //   style: TextStyle(
                //     fontSize: 12,
                //     //  color: Theme.of(context).colorScheme.primary
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );

    return Draggable<Task>(
      data: task,
      feedback: Opacity(
        opacity: 0.8,
        child: SizedBox(
          width: 276, // 300 - 24 padding
          child: card,
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      child: card,
    );
  }
}
