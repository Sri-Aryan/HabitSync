import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/habit_provider.dart';
import '../core/theme/app_theme.dart';
import '../widgets/habit_card.dart';
import '../widgets/floating_bottom_nav.dart';
import 'add_habit_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const StatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: FloatingBottomNav(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Aryan',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.local_fire_department,
                            value: habits.isNotEmpty
                                ? habits
                                .map((h) => h.getCurrentStreak())
                                .reduce((a, b) => a > b ? a : b)
                                .toString()
                                : '0',
                            label: 'Day Streak',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle,
                            value: habits.length.toString(),
                            label: 'Total Habits',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Today\'s Habits',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (habits.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_task,
                        size: 80,
                        color: AppTheme.grey.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No habits yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first habit',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: HabitCard(habit: habits[index]),
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
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.white, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
