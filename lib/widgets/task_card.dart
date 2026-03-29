import 'package:daily_driver/constants.dart';
import 'package:daily_driver/util.dart';
import 'package:flutter/material.dart';
import 'package:daily_driver/models/task.dart';
import 'package:daily_driver/widgets/add_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final void Function(Task, bool) onChanged;

  const TaskCard({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;

    return Opacity(
      opacity: isCompleted ? 0.5 : 1,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: isCompleted
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddTaskDialog(task: task),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  shape: CircleBorder(),
                  value: isCompleted,
                  onChanged: (value) {
                    onChanged(task, value!);
                  },
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (task.dueDate != null) ...[
                            Icon(
                              Icons.access_time,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                              color: formatTaskDate(
                                task.dueDate!.toDate(),
                              )['color'],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatTaskDate(task.dueDate!.toDate())['text'],
                              style: TextStyle(
                                color: formatTaskDate(
                                  task.dueDate!.toDate(),
                                )['color'],
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.fontSize,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],

                          if (task.dueDate != null &&
                              task.isRecurring == true) ...[
                            Icon(
                              Icons.repeat_rounded,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                            ),
                            const SizedBox(width: 8),
                          ],

                          if (labels[task.label] != null) ...[
                            Icon(
                              Icons.local_offer_outlined,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                              color: labels[task.label]!['color'],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              labels[task.label]!['name'],
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.fontSize,
                                color: labels[task.label]!['color'],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
