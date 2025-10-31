import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/habit_provider.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/notification_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _showTestNotification(BuildContext context) async {
    try {
      await NotificationService.showInstantNotification(
        id: 999,
        title: '🎉 Test Notification',
        body: 'This is a test notification from Habit Tracker!',
        quote: 'Success is the sum of small efforts repeated day in and day out.',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            backgroundColor: AppTheme.lightBlue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

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
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppTheme.lightBlue, AppTheme.darkBlue],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightBlue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '👤',
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Raunak',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Building better habits',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Test Notification Button
                    _buildTestNotificationButton(context),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage your reminders',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Appearance',
                      subtitle: 'Theme preferences',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.backup_outlined,
                      title: 'Backup & Restore',
                      subtitle: 'Sync your data',
                      onTap: () {},
                    ),
                    _buildSettingItem(
                      icon: Icons.info_outlined,
                      title: 'About',
                      subtitle: 'App version 1.0.0',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    if (habits.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text('Clear All Habits?'),
                              content: const Text(
                                'This will delete all your habits and progress. This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    for (final habit in habits) {
                                      ref
                                          .read(habitProvider.notifier)
                                          .deleteHabit(habit.id);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete All',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        label: const Text(
                          'Clear All Habits',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestNotificationButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.lightBlue, AppTheme.darkBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTestNotification(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: AppTheme.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Notification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Send instant test notification',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightBlue.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.lightBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
