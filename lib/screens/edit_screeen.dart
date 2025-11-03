import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/habit_provider.dart';
import '../core/theme/app_theme.dart';
import '../models/habit_model.dart';

class EditHabitBottomSheet extends ConsumerStatefulWidget {
  final Habit habit;

  const EditHabitBottomSheet({super.key, required this.habit});

  @override
  ConsumerState<EditHabitBottomSheet> createState() => _EditHabitBottomSheetState();
}

class _EditHabitBottomSheetState extends ConsumerState<EditHabitBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _quoteController;
  late String _selectedIcon;
  late String _selectedFrequency;
  late int _goal;
  TimeOfDay? _reminderTime;

  final List<String> _icons = [
    '💧', '📖', '🏃', '🧘', '💪', '🎨', '📝', '🎯',
    '🌱', '☕', '💤', '🎵', '🍎', '🧠', '⏰', '🌟'
  ];

  final List<String> _frequencies = ['Daily', 'Weekly'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _quoteController = TextEditingController(text: widget.habit.quote ?? '');
    _selectedIcon = widget.habit.icon;
    _selectedFrequency = widget.habit.frequency;
    _goal = widget.habit.goal;
    if (widget.habit.reminderTime != null) {
      _reminderTime = TimeOfDay.fromDateTime(widget.habit.reminderTime!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.lightBlue,
              onPrimary: AppTheme.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _saveChanges() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a habit name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    DateTime? reminderDateTime;
    if (_reminderTime != null) {
      final now = DateTime.now();
      reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _reminderTime!.hour,
        _reminderTime!.minute,
      );
    }

    final updatedHabit = widget.habit.copyWith(
      name: _nameController.text.trim(),
      icon: _selectedIcon,
      frequency: _selectedFrequency,
      goal: _goal,
      reminderTime: reminderDateTime,
      quote: _quoteController.text.trim().isNotEmpty
          ? _quoteController.text.trim()
          : null,
    );

    ref.read(habitProvider.notifier).updateHabit(updatedHabit);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habit updated successfully!'),
        backgroundColor: AppTheme.lightBlue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Habit?'),
        content: Text(
          'Are you sure you want to delete "${widget.habit.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(habitProvider.notifier).deleteHabit(widget.habit.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Habit deleted'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Habit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppTheme.grey,
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Icon',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _icons.length,
                      itemBuilder: (context, index) {
                        final icon = _icons[index];
                        final isSelected = icon == _selectedIcon;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 70,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightBlue
                                  : AppTheme.lightGrey,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightBlue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                icon,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Habit Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Drink Water',
                      filled: true,
                      fillColor: AppTheme.lightGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Frequency',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _frequencies.map((frequency) {
                      final isSelected = frequency == _selectedFrequency;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFrequency = frequency;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightBlue
                                  : AppTheme.lightGrey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                frequency,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppTheme.white
                                      : AppTheme.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Goal (days per week)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_goal days',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_goal > 1) {
                                  setState(() {
                                    _goal--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppTheme.lightBlue,
                            ),
                            IconButton(
                              onPressed: () {
                                if (_goal < 7) {
                                  setState(() {
                                    _goal++;
                                  });
                                }
                              },
                              icon: const Icon(Icons.add_circle_outline),
                              color: AppTheme.lightBlue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Reminder Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _reminderTime != null
                                ? _reminderTime!.format(context)
                                : 'Set reminder time',
                            style: TextStyle(
                              fontSize: 16,
                              color: _reminderTime != null
                                  ? AppTheme.black
                                  : AppTheme.grey,
                            ),
                          ),
                          const Icon(
                            Icons.access_time,
                            color: AppTheme.lightBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Motivational Quote (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _quoteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'e.g., Small steps lead to big changes',
                      filled: true,
                      fillColor: AppTheme.lightGrey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _deleteHabit,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
