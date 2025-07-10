import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';

part 'route_controller.g.dart';

class RouteController {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;
      
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignup = state.matchedLocation == '/signup';
      final isGoingToHome = state.matchedLocation == '/home';
      
      // If user is not logged in and trying to access protected routes
      if (!isLoggedIn && !isGoingToLogin && !isGoingToSignup) {
        return '/login';
      }
      
      // If user is logged in and trying to access auth pages
      if (isLoggedIn && (isGoingToLogin || isGoingToSignup)) {
        return '/home';
      }
      
      // If user is not logged in and on root, redirect to login
      if (!isLoggedIn && state.matchedLocation == '/') {
        return '/login';
      }
      
      // If user is logged in and on root, redirect to home
      if (isLoggedIn && state.matchedLocation == '/') {
        return '/home';
      }
      
      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}

@riverpod
GoRouter router(Ref ref) {
  return RouteController.router;
}
