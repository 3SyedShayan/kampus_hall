import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/login_transition_screen.dart';
import 'screens/select_interests_screen.dart';
import 'screens/home_screen.dart';
import 'screens/select_interests.dart';
import 'screens/chat_screen.dart';
import 'screens/society_chat_screen.dart';

void main() {
  runApp(const KampusHallApp());
}

class KampusHallApp extends StatelessWidget {
  const KampusHallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kampus Hall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff85F0F7)),
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xffEFEFEF),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        LoginTransitionScreen.routeName: (_) => const LoginTransitionScreen(),
        SelectInterestsScreen.routeName: (_) => const SelectInterestsScreen(),
        SelectInterests.routeName: (_) => const SelectInterests(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        ChatScreen.routeName: (_) => const ChatScreen(),
        SocietyChatScreen.routeName: (_) => const SocietyChatScreen(),
      },
    );
  }
}
