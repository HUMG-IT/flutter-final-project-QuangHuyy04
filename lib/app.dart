// lib/app.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bookverse/core/theme_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/auth/presentation/profile_screen.dart';
import 'features/book/presentation/screens/book_list_screen.dart';
import 'features/book/presentation/screens/add_book_screen.dart';
import 'features/book/presentation/screens/edit_book_screen.dart';
import 'features/book/presentation/screens/statistics_screen.dart';
import 'features/book/data/book_model.dart';
import 'features/book/presentation/providers/book_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isAuthRoute = ['/', '/register'].contains(state.uri.path);

      if (!isLoggedIn && !isAuthRoute) {
        ref.invalidate(booksProvider);
        return '/';
      }
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (_, __) => const BookListScreen()),
      GoRoute(path: '/add-book', builder: (_, __) => const AddBookScreen()),
      GoRoute(path: '/edit-book', builder: (_, state) => EditBookScreen(book: state.extra as Book)),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/statistics', builder: (_, __) => const StatisticsScreen()),
    ],
  );
});

class BookVerseApp extends ConsumerWidget {
  const BookVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'BookVerse',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}