import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/habit_provider.dart';
import '../core/theme/app_theme.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    final totalHabits = habits.length;
    final totalCompletions = habits.fold<int>(
      0,
          (sum, habit) => sum + habit.getTotalCompletedDays(),
    );
    final maxStreak = habits.isNotEmpty
        ? habits
        .map((h) => h.getCurrentStreak())
        .reduce((a, b) => a > b ? a : b)
        : 0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.white, AppTheme.lightGrey],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your progress overview',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildStatCard(
                      icon: Icons.emoji_events,
                      title: 'Total Habits',
                      value: totalHabits.toString(),
                      color: AppTheme.lightBlue,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.check_circle,
                      title: 'Total Completions',
                      value: totalCompletions.toString(),
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    _buildStatCard(
                      icon: Icons.local_fire_department,
                      title: 'Longest Streak',
                      value: '$maxStreak days',
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Habit Breakdown',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (habits.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No habits to show stats for',
                    style: TextStyle(color: AppTheme.grey),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final habit = habits[index];
                      final progress = habit.getCompletedDaysThisWeek() / 7;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    habit.icon,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      habit.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${(progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.lightBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  backgroundColor: AppTheme.lightGrey,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Completed: ${habit.getTotalCompletedDays()} days',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.grey,
                                    ),
                                  ),
                                  Text(
                                    'Streak: ${habit.getCurrentStreak()}🔥',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: habits.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
