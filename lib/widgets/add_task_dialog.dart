import 'package:daily_driver/constants.dart';
import 'package:daily_driver/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  final Task? task;
  final bool initialIsLater;
  const AddTaskDialog({super.key, this.task, this.initialIsLater = false});

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _customDaysController = TextEditingController();
  final _labelMenuController = MenuController();
  final _recurrenceMenuController = MenuController();

  final _labelsArray = labels.keys.toList();
  final _recurrenceOptionsArray = recurrenceOptions.keys.toList();

  DateTime? _selectedDueDate;
  String? _selectedLabel;
  String? _selectedRecurrenceOption;

  String? _moveTo;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      if (widget.task!.title.isNotEmpty) {
        _titleController.text = widget.task!.title;
      }
      if (widget.task!.label != null) {
        _selectedLabel = widget.task!.label;
      }
      if (widget.task!.recurrenceInterval != null) {
        _selectedRecurrenceOption = widget.task!.recurrenceInterval;
      }
      if (widget.task!.customRecurrenceDays != null) {
        _customDaysController.text =
            widget.task!.customRecurrenceDays?.toString() ?? "";
      }
      if (widget.task!.dueDate != null) {
        _selectedDueDate = widget.task!.dueDate!.toDate();
      }
      if (widget.task!.dueDate == null &&
          (widget.task!.isLater == false || widget.task!.isLater == null)) {
        _moveTo = 'Later';
      }
      if (widget.task!.dueDate == null && widget.task!.isLater == true) {
        _moveTo = 'To-Do';
      }
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _showCustomDaysDialog() async {
    final initialValue = _customDaysController.text.isEmpty
        ? '1'
        : _customDaysController.text;
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: initialValue);
        return AlertDialog(
          title: const Text('Custom Recurrence'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Number of days',
              suffixText: 'days',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty &&
                    int.tryParse(controller.text) != null) {
                  Navigator.pop(context, controller.text);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _customDaysController.text = result;
        _selectedRecurrenceOption = 'custom';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Task name (enter multiple lines for bulk add)',
                border: InputBorder.none,
                hintStyle: TextStyle(),
              ),
              autofocus: true,
              maxLines: null,
            ),
            const SizedBox(height: 16),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                //Date Option
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: _selectDueDate,
                    ),
                    if (_selectedDueDate != null)
                      InputChip(
                        label: Text(
                          formatTaskDate(_selectedDueDate!)['text'],
                          style: TextStyle(
                            color: formatTaskDate(_selectedDueDate!)['color'],
                            fontSize: Theme.of(
                              context,
                            ).textTheme.labelMedium?.fontSize,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedDueDate = null;
                            _selectedRecurrenceOption = null;
                          });
                        },
                      ),
                  ],
                ),
                //Recurrence Option
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MenuAnchor(
                      controller: _recurrenceMenuController,
                      menuChildren: [
                        for (var option in _recurrenceOptionsArray)
                          MenuItemButton(
                            leadingIcon: Icon(
                              Icons.repeat_rounded,
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                            ),
                            child: Text(
                              recurrenceOptions[option]!,
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.fontSize,
                              ),
                            ),
                            onPressed: () {
                              if (option == 'custom') {
                                _showCustomDaysDialog();
                              } else {
                                setState(() {
                                  _selectedRecurrenceOption = option;
                                });
                              }
                            },
                          ),
                      ],
                      builder: (context, controller, child) {
                        return IconButton(
                          icon: const Icon(Icons.repeat_rounded),
                          onPressed: _selectedDueDate == null
                              ? null
                              : () {
                                  if (controller.isOpen) {
                                    controller.close();
                                  } else {
                                    controller.open();
                                  }
                                },
                        );
                      },
                    ),
                    if (_selectedRecurrenceOption != null)
                      InputChip(
                        label: Text(
                          _selectedRecurrenceOption == 'custom'
                              ? 'Custom (${_customDaysController.text.isEmpty ? '?' : _customDaysController.text} days)'
                              : recurrenceOptions[_selectedRecurrenceOption]!,
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.labelMedium?.fontSize,
                          ),
                        ),
                        onPressed: _selectedRecurrenceOption == 'custom'
                            ? _showCustomDaysDialog
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedRecurrenceOption = null;
                            _customDaysController.clear();
                          });
                        },
                      ),
                  ],
                ),

                //Labels Option
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MenuAnchor(
                      controller: _labelMenuController,
                      menuChildren: [
                        for (var label in _labelsArray)
                          MenuItemButton(
                            leadingIcon: Icon(
                              Icons.local_offer_outlined,
                              color: labels[label]!['color'],
                              size: Theme.of(
                                context,
                              ).textTheme.labelMedium?.fontSize,
                            ),
                            child: Text(
                              labels[label]!['name'],
                              style: TextStyle(
                                color: labels[label]!['color'],
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.fontSize,
                              ),
                            ),
                            onPressed: () => {
                              setState(() {
                                _selectedLabel = label;
                              }),
                            },
                          ),
                      ],
                      builder: (context, controller, child) {
                        return IconButton(
                          icon: const Icon(Icons.local_offer_outlined),
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                        );
                      },
                    ),
                    if (_selectedLabel != null)
                      InputChip(
                        label: Text(
                          labels[_selectedLabel]!['name'],
                          style: TextStyle(
                            color: labels[_selectedLabel]!['color'],
                            fontSize: Theme.of(
                              context,
                            ).textTheme.labelMedium?.fontSize,
                          ),
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onDeleted: () {
                          setState(() {
                            _selectedLabel = null;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.task != null)
                  MenuAnchor(
                    builder: (context, controller, child) {
                      return IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                      );
                    },
                    menuChildren: [
                      MenuItemButton(
                        leadingIcon: Icon(
                          Icons.delete_outline,
                          color: Color.lerp(Colors.red, Colors.black, 0.5),
                        ),
                        onPressed: _deleteTask,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Color.lerp(Colors.red, Colors.black, 0.5),
                          ),
                        ),
                      ),
                      if (_moveTo != null)
                        MenuItemButton(
                          leadingIcon: Icon(Icons.output_outlined),
                          onPressed: _moveTask,
                          child: Text(_moveTo!),
                        ),
                    ],
                  ),
                const Spacer(),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _moveTask() {
    if (widget.task != null) {
      if (_moveTo == 'Later') {
        final updatedTask = widget.task!.copyWith(isLater: true);
        ref.read(taskRepositoryProvider).updateTask(updatedTask);
      } else if (_moveTo == 'To-Do') {
        final updatedTask = widget.task!.copyWith(isLater: false);
        ref.read(taskRepositoryProvider).updateTask(updatedTask);
      }
    }
    Navigator.pop(context);
  }

  void _submit() {
    final fullText = _titleController.text.trim();
    if (fullText.isEmpty) return;

    final taskRepo = ref.read(taskRepositoryProvider);

    if (widget.task != null) {
      final updatedTask = widget.task!.copyWith(
        id: widget.task!.id,
        title: fullText,
        status: widget.task!.status,
        label: _selectedLabel,
        dueDate: _selectedDueDate != null
            ? Timestamp.fromDate(_selectedDueDate!)
            : null,
        createdAt: widget.task!.createdAt,
        inProgressAt: widget.task!.inProgressAt,
        completedAt: widget.task!.completedAt,
        isRecurring: _selectedRecurrenceOption != null ? true : false,
        recurrenceInterval: _selectedRecurrenceOption,
        position: widget.task!.position,
        customRecurrenceDays: int.tryParse(_customDaysController.text),
      );
      taskRepo.updateTask(updatedTask);
    } else {
      final titles = fullText
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (final title in titles) {
        final newTask = Task(
          id: taskRepo.generateTaskId(),
          title: title,
          status: TaskStatus.todo,
          label: _selectedLabel,
          dueDate: _selectedDueDate != null
              ? Timestamp.fromDate(_selectedDueDate!)
              : null,
          createdAt: Timestamp.now(),
          isRecurring: _selectedRecurrenceOption != null ? true : false,
          recurrenceInterval: _selectedRecurrenceOption,
          customRecurrenceDays: int.tryParse(_customDaysController.text),
          isLater: _selectedDueDate == null ? widget.initialIsLater : false,
        );
        taskRepo.createTask(newTask);
      }
    }

    Navigator.pop(context);
  }

  void _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Color.lerp(Colors.red, Colors.black, 0.2),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && widget.task != null) {
      if (mounted) {
        ref.read(taskRepositoryProvider).deleteTask(widget.task!.id);
        Navigator.pop(context);
      }
    }
  }
}
