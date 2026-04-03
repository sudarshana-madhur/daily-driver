import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../widgets/task_card.dart';

class KanbanBoard extends ConsumerStatefulWidget {
  const KanbanBoard({super.key});

  @override
  ConsumerState<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends ConsumerState<KanbanBoard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 800),
    );
    // Initialize audio player
    ensureAudioInitialized();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(todayTaskListProvider);
    final completedTasksAsync = ref.watch(completedTodayTaskListProvider);

    return tasksAsync.when(
      data: (tasks) => completedTasksAsync.when(
        data: (completedTasks) {
          final allTasks = [...tasks, ...completedTasks];
          final todoTasks = allTasks
              .where((t) => t.status == TaskStatus.todo)
              .toList();
          final inProgressTasks = allTasks
              .where((t) => t.status == TaskStatus.inProgress)
              .toList();
          final doneTasks = allTasks
              .where((t) => t.status == TaskStatus.completed)
              .toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;
              final laneWidth = isMobile
                  ? 300.0
                  : (constraints.maxWidth - 64) / 3;

              final content = Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLane(
                    context,
                    'To-Do',
                    TaskStatus.todo,
                    todoTasks,
                    laneWidth,
                  ),
                  const SizedBox(width: 16),
                  _buildLane(
                    context,
                    'In-Progress',
                    TaskStatus.inProgress,
                    inProgressTasks,
                    laneWidth,
                    color: Colors.amber.withOpacity(0.05),
                  ),
                  const SizedBox(width: 16),
                  _buildLane(
                    context,
                    'Completed',
                    TaskStatus.completed,
                    doneTasks,
                    laneWidth,
                    color: Colors.green.withOpacity(0.05),
                  ),
                ],
              );

              if (isMobile) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32,
                    ),
                    child: content,
                  ),
                );
              }

              return Padding(padding: const EdgeInsets.all(16), child: content);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildLane(
    BuildContext context,
    String title,
    TaskStatus status,
    List<Task> tasks,
    double width, {
    Color? color,
  }) {
    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) => details.data.status != status,
      onAcceptWithDetails: (details) async {
        ref.read(taskRepositoryProvider).updateTaskStatus(details.data, status);

        if (status == TaskStatus.completed) {
          // Play sound
          playCompletionSound();
          // Haptic feedback
          HapticFeedback.mediumImpact();
          // Trigger confetti
          _confettiController.play();
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isDraggingOver = candidateData.isNotEmpty;

        return Container(
          width: width,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: isDraggingOver
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background Tint
              if (color != null)
                Positioned.fill(
                  child: Container(
                    color: color.withOpacity(isDraggingOver ? 0.2 : 0.1),
                  ),
                ),

              // Confetti
              if (status == TaskStatus.completed)
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple,
                    ],
                    numberOfParticles: 20,
                    gravity: 0.1,
                    maxBlastForce: 15,
                    minBlastForce: 5,
                    strokeWidth: 1,
                  ),
                ),

              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${tasks.length}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      padding: const EdgeInsets.all(8),
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
                              mutableTasks[mutableTasks.length - 2].position +
                              100000.0;
                        } else {
                          newPosition =
                              (mutableTasks[newIndex - 1].position +
                                  mutableTasks[newIndex + 1].position) /
                              2.0;
                        }

                        ref
                            .read(taskRepositoryProvider)
                            .updateTask(
                              movedTask.copyWith(position: newPosition),
                            );
                      },
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _DraggableTaskCard(
                          key: ValueKey(task.id),
                          task: task,
                          index: index,
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Foreground Tint Overlay (to show tint OVER cards as requested)
              if (color != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(color: color.withOpacity(0.05)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DraggableTaskCard extends ConsumerStatefulWidget {
  final Task task;
  final int index;

  const _DraggableTaskCard({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  ConsumerState<_DraggableTaskCard> createState() => _DraggableTaskCardState();
}

class _DraggableTaskCardState extends ConsumerState<_DraggableTaskCard> {
  bool _isDraggingForLane = false;

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final index = widget.index;

    final taskCard = TaskCard(
      task: task,
      showCheckbox: false,
      dragHandle: Draggable<Task>(
        data: task,
        onDragStarted: () {
          setState(() {
            _isDraggingForLane = true;
          });
        },
        onDragEnd: (details) {
          setState(() {
            _isDraggingForLane = false;
          });
        },
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            _isDraggingForLane = false;
          });
        },
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: TaskCard(
              task: task,
              showCheckbox: false,
              onChanged: (_, __) {},
            ),
          ),
        ),
        child: Opacity(
          opacity: 0.2,
          child: Icon(
            Icons.drag_indicator,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),

      onChanged: (updatedTask, isCompleted) {
        ref
            .read(taskRepositoryProvider)
            .updateTaskStatus(
              task,
              isCompleted ? TaskStatus.completed : TaskStatus.todo,
            );
      },
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Opacity(
        opacity: _isDraggingForLane ? 0.4 : 1.0,
        child: ReorderableDelayedDragStartListener(
          index: index,
          child: taskCard,
        ),
      ),
    );
  }
}
