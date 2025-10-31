import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/habit_provider.dart';
import '../core/theme/app_theme.dart';
import '../models/habit_model.dart';
import 'package:intl/intl.dart';

import '../screens/edit_screeen.dart';

class HabitCard extends ConsumerStatefulWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  ConsumerState<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends ConsumerState<HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => EditHabitBottomSheet(habit: widget.habit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.habit.isCompletedToday();
    final streak = widget.habit.getCurrentStreak();
    final completedThisWeek = widget.habit.getCompletedDaysThisWeek();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _showEditBottomSheet, // CHANGED: Opens bottom sheet
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            widget.habit.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.habit.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.habit.frequency} • Goal: ${widget.habit.goal} days',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _controller.forward();
                          await ref
                              .read(habitProvider.notifier)
                              .toggleCompletion(widget.habit.id);
                          await _controller.reverse();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightBlue
                                : Colors.transparent,
                            border: Border.all(
                              color: isCompleted
                                  ? AppTheme.lightBlue
                                  : AppTheme.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isCompleted
                              ? const Icon(
                            Icons.check,
                            color: AppTheme.white,
                            size: 18,
                          )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        icon: Icons.local_fire_department,
                        value: '$streak',
                        label: 'Streak',
                      ),
                      _buildStatItem(
                        icon: Icons.calendar_today,
                        value: '$completedThisWeek/7',
                        label: 'This Week',
                      ),
                      if (widget.habit.reminderTime != null)
                        _buildStatItem(
                          icon: Icons.access_time,
                          value: DateFormat.jm().format(widget.habit.reminderTime!),
                          label: 'Reminder',
                        ),
                    ],
                  ),
                  if (widget.habit.quote != null && widget.habit.quote!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.format_quote,
                            color: AppTheme.lightBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.habit.quote!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.black,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.grey),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
