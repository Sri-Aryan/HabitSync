import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class FloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FloatingBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          // Far shadow (darkest, most spread)
          BoxShadow(
            color: AppTheme.lightBlue.withOpacity(0.08),
            blurRadius: 60,
            spreadRadius: 10,
            offset: const Offset(0, 30),
          ),
          // Mid shadow
          BoxShadow(
            color: AppTheme.black.withOpacity(0.12),
            blurRadius: 40,
            spreadRadius: 2,
            offset: const Offset(0, 20),
          ),
          // Close shadow
          BoxShadow(
            color: AppTheme.black.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          // light shadow
          BoxShadow(
            color: AppTheme.lightBlue.withOpacity(0.1),
            blurRadius: 50,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.white.withOpacity(0.98),
                  AppTheme.white.withOpacity(0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppTheme.white.withOpacity(0.6),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Stats',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightBlue.withOpacity(0.2),
              AppTheme.lightBlue.withOpacity(0.1),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppTheme.lightBlue.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.lightBlue : AppTheme.grey,
                size: isSelected ? 26 : 24,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds:  300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightBlue,
                    ),
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
