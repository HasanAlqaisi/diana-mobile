import 'package:diana/presentation/habit/pages/add_habit_bottom_sheet.dart';
import 'package:diana/presentation/habit/pages/habit_screen.dart';
import 'package:diana/presentation/home/home.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:diana/presentation/nav/nav.dart';
import 'package:diana/presentation/profile/pages/profile_screen.dart';
import 'package:diana/presentation/register/pages/register_screen.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';
import 'package:diana/presentation/task/pages/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/notifications/local_notifications.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  await LocalNotifications.initNotifications();

  tz.initializeTimeZones();

  runApp(Diana());
}

class Diana extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF612EF3),
          backwardsCompatibility: true,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Color(0xFF612EF3)),
          brightness: Brightness.dark,
        ),
        backgroundColor: Color(0xFFE5E5E5),
        primarySwatch: MaterialColor(
          0xFF6504C2,
          const <int, Color>{
            50: const Color(0xFF6504C2),
            100: const Color(0xFF6504C2),
            200: const Color(0xFF6504C2),
            300: const Color(0xFF6504C2),
            400: const Color(0xFF6504C2),
            500: const Color(0xFF6504C2),
            600: const Color(0xFF6504C2),
            700: const Color(0xFF6504C2),
            800: const Color(0xFF6504C2),
            900: const Color(0xFF6504C2),
          },
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Home.route,
      routes: {
        Home.route: (context) => Home(),
        Nav.route: (context) => Nav(),
        LoginScreen.route: (context) => LoginScreen(),
        RegisterScreen.route: (context) => RegisterScreen(),
        TaskScreen.route: (context) => TaskScreen(),
        AddTaskScreen.route: (context) => AddTaskScreen(),
        HabitScreen.route: (context) => HabitScreen(),
        AddHabitBottomSheet.route: (context) => AddHabitBottomSheet(),
        ProfileScreen.route: (context) => ProfileScreen(),
      },
    );
  }
}
