# HabitSync 

A modern, feature-rich habit tracking application built with Flutter that helps users build better habits through daily tracking, smart reminders, and visual progress monitoring.

## 📱 About

HabitSync is a cross-platform mobile application designed to help users create, track, and maintain positive habits. With an intuitive interface, powerful notification system, and detailed analytics, users can build lasting habits and achieve their personal goals.

## ✨ Features

### Core Functionality
- **Habit Management**: Create, edit, and delete custom habits with personalized icons, frequencies, and goals
- **Daily Tracking**: Mark habits as complete with visual checkboxes and track completion history
- **Smart Notifications**: Schedule daily reminders with custom motivational quotes at specific times
- **Streak Tracking**: Monitor consecutive days of completion with automatic streak calculation
- **Progress Analytics**: View detailed statistics including weekly completion rates and total achievements

### Authentication & Security
- **Firebase Authentication**: Secure email/password and Google OAuth sign-in
- **Session Management**: Persistent authentication state across app sessions
- **Password Recovery**: Email-based password reset functionality

### User Experience
- **Modern UI/UX**: Clean, minimalist design with smooth animations and transitions
- **Glassmorphism Navigation**: Floating bottom navigation bar with blur effects
- **Interactive Cards**: Tap-to-edit habit cards with modal bottom sheet interface
- **Animated Splash Screen**: Professional app launch experience
- **Dark Theme Ready**: Light blue, white, and black color scheme

### Data & Sync
- **Local Storage**: Fast, offline-first data persistence using SharedPreferences
- **JSON Serialization**: Efficient habit data structure with completion history
- **Real-time Updates**: Riverpod-powered reactive state management

## 🛠 Tech Stack

### Frontend Framework
- **Flutter** - Cross-platform mobile development framework
- **Dart 3.8.1+** - Programming language

### State Management
- **Riverpod 2.5.1** - Type-safe reactive state management
  - StateNotifier for habit management
  - StreamProvider for authentication state
  - Provider for dependency injection

### Backend & Cloud Services
- **Firebase Core 3.12.1** - Firebase SDK integration
- **Firebase Auth 5.5.1** - User authentication
- **Google Sign-In 6.2.2** - OAuth authentication provider

### Local Storage
- **SharedPreferences 2.2.3** - Key-value persistence
- **JSON encoding/decoding** - Data serialization

### Notifications
- **flutter_local_notifications 17.2.3** - Local notification management
- **timezone 0.9.4** - Timezone-aware scheduling
- **flutter_timezone 3.0.1** - Device timezone detection
- **permission_handler 11.3.1** - Runtime permissions handling

### Build Configuration
- **Gradle Kotlin DSL** - Modern build configuration
- **Android SDK 34** - Target Android version
- **Core Library Desugaring** - Java 11 compatibility for older Android versions

### Additional Libraries
- **intl** - Date/time formatting and internationalization
- **animations 2.0.11** - Pre-built animation widgets
- **cupertino_icons** - iOS-style icons

