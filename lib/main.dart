import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/issue_provider.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const CivicIssuesApp());
}

class CivicIssuesApp extends StatelessWidget {
  const CivicIssuesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => IssueProvider()),
      ],
      child: MaterialApp(
        title: 'Civic Reporter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}