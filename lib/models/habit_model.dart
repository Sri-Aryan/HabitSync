class Habit {
  final String id;
  final String name;
  final String icon;
  final String frequency;
  final int goal;
  final DateTime? reminderTime;
  final String? quote;
  final Map<String, bool> completions;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.frequency,
    required this.goal,
    this.reminderTime,
    this.quote,
    Map<String, bool>? completions,
    DateTime? createdAt,
  })  : completions = completions ?? {},
        createdAt = createdAt ?? DateTime.now();

  bool isCompletedToday() {
    final today = DateTime.now();
    final key = '${today.year}-${today.month}-${today.day}';
    return completions[key] ?? false;
  }

  int getCompletedDaysThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    int count = 0;

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final key = '${day.year}-${day.month}-${day.day}';
      if (completions[key] == true) count++;
    }
    return count;
  }

  int getTotalCompletedDays() {
    return completions.values.where((v) => v == true).length;
  }

  int getCurrentStreak() {
    int streak = 0;
    final now = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final day = now.subtract(Duration(days: i));
      final key = '${day.year}-${day.month}-${day.day}';
      if (completions[key] == true) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  Habit copyWith({
    String? name,
    String? icon,
    String? frequency,
    int? goal,
    DateTime? reminderTime,
    String? quote,
    Map<String, bool>? completions,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      frequency: frequency ?? this.frequency,
      goal: goal ?? this.goal,
      reminderTime: reminderTime ?? this.reminderTime,
      quote: quote ?? this.quote,
      completions: completions ?? this.completions,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'frequency': frequency,
      'goal': goal,
      'reminderTime': reminderTime?.toIso8601String(),
      'quote': quote,
      'completions': completions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      frequency: json['frequency'],
      goal: json['goal'],
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      quote: json['quote'],
      completions: Map<String, bool>.from(json['completions'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
