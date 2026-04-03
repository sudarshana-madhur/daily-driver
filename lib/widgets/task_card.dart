import 'package:daily_driver/constants.dart';
import 'package:daily_driver/util.dart';
import 'package:flutter/material.dart';
import 'package:daily_driver/models/task.dart';
import 'package:daily_driver/widgets/add_task_dialog.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:confetti/confetti.dart';

// Shared AudioPlayer singleton for efficient resource management
final AudioPlayer sharedAudioPlayer = AudioPlayer();
bool _hasStartedInitialization = false;

// Ensure audio is initialized only once for the entire app lifecycle
Future<void> ensureAudioInitialized() async {
  if (_hasStartedInitialization) return;
  _hasStartedInitialization = true;
  try {
    debugPrint('TaskCard: One-time global initialization of popp.mp3');
    await sharedAudioPlayer.setAsset('assets/popp.mp3');
    debugPrint('TaskCard: Global audio initialization successful');
  } catch (e) {
    _hasStartedInitialization = false; // Allow retry if it failed
    debugPrint('TaskCard: Global audio initialization failed: $e');
  }
}

Future<void> playCompletionSound() async {
  try {
    await ensureAudioInitialized();
    // Stop and reset the shared player to allow rapid replay
    if (sharedAudioPlayer.playing) {
      await sharedAudioPlayer.stop();
    }
    await sharedAudioPlayer.seek(Duration.zero);
    // We don't await play() to ensure the UI animation continues immediately
    sharedAudioPlayer.play();
  } catch (e) {
    debugPrint('TaskCard: Playback error: $e');
  }
}

class TaskCard extends StatefulWidget {
  final Task task;
  final void Function(Task, bool) onChanged;
  final bool showCheckbox;
  final Widget? dragHandle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onChanged,
    this.showCheckbox = true,
    this.dragHandle,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late ConfettiController _confettiController;
  bool _forceCompleted = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 800),
    );

    // Trigger the global initialization once
    ensureAudioInitialized();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _handleCompletion(bool value) async {
    if (value) {
      if (_isProcessing) return;

      setState(() {
        _isProcessing = true;
        _forceCompleted = true;
      });

      // 1. Play completion sound immediately
      await playCompletionSound();

      // 2. Trigger haptic feedback
      await HapticFeedback.mediumImpact();

      // 3. Trigger confetti
      _confettiController.play();

      // 4. Stay in the completed state for a second so the user can enjoy the reward
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        widget.onChanged(widget.task, value);
      }
    } else {
      widget.onChanged(widget.task, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted =
        widget.task.status == TaskStatus.completed || _forceCompleted;

    return Opacity(
      opacity: isCompleted ? 0.5 : 1,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.none,
        child: InkWell(
          onTap: isCompleted
              ? null
              : () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddTaskDialog(task: widget.task),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                if (widget.dragHandle != null) ...[
                  widget.dragHandle!,
                  const SizedBox(width: 8),
                ],
                if (widget.showCheckbox) ...[
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Checkbox(
                        shape: const CircleBorder(),
                        value: isCompleted,
                        onChanged: _isProcessing
                            ? null
                            : (value) => _handleCompletion(value!),
                      ),
                      ConfettiWidget(
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
                        numberOfParticles: 12,
                        gravity: 0.1,
                        maxBlastForce: 5,
                        minBlastForce: 2,
                        strokeWidth: 1,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ] else
                  const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.task.title,
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
                          if (widget.task.dueDate != null) ...[
                            Icon(
                              Icons.access_time,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                              color: formatTaskDate(
                                widget.task.dueDate!.toDate(),
                              )['color'],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatTaskDate(
                                widget.task.dueDate!.toDate(),
                              )['text'],
                              style: TextStyle(
                                color: formatTaskDate(
                                  widget.task.dueDate!.toDate(),
                                )['color'],
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.fontSize,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (widget.task.dueDate != null &&
                              widget.task.isRecurring == true) ...[
                            Icon(
                              Icons.repeat_rounded,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (labels[widget.task.label] != null) ...[
                            Icon(
                              Icons.local_offer_outlined,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                              color: labels[widget.task.label]!['color'],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              labels[widget.task.label]!['name'],
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.fontSize,
                                color: labels[widget.task.label]!['color'],
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
