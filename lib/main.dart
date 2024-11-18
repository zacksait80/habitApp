import 'package:flutter/material.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kodu_ko/models/routine.dart';
import 'package:kodu_ko/models/task.dart';
import 'package:kodu_ko/models/task_event.dart';
import 'package:kodu_ko/screens/about.dart';
import 'package:kodu_ko/screens/app.dart';
import 'package:kodu_ko/screens/archive_routines.dart';
import 'package:kodu_ko/screens/onboarding.dart';
import 'package:kodu_ko/screens/stats.dart';
import 'package:kodu_ko/screens/tasks.dart';
import 'package:kodu_ko/services/notification_service.dart';
import 'package:kodu_ko/services/routines_provider.dart';
import 'package:kodu_ko/services/tasks_provider.dart';
import 'package:kodu_ko/services/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(RoutineAdapter());
  Hive.registerAdapter(TaskEventAdapter());

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  _configureLocalTimeZone();
  runApp(const MyApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  // final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Hive.openBox<Routine>("Routines"),
        Hive.openBox<Task>("Tasks"),
        Hive.openBox<bool>("Theme"),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text(
                  "Oops! Try again later",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final box = Hive.box<bool>('Theme');
          String initRoute = '/';
          if (box.isOpen) {
            initRoute =
                (box.get('isNewUser') ?? true) ? OnBoarding.routeName : '/';
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => RoutineModel(),
              ),
              ChangeNotifierProvider(
                create: (context) => TaskModel(),
              ),
              ChangeNotifierProvider(
                create: ((context) => ThemeModel()),
              ),
            ],
            child: Consumer<ThemeModel>(
              builder: (context, value, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'HT',
                  themeMode: value.getTheme,
                  theme: ThemeData.light(useMaterial3: true).copyWith(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.purple,
                      brightness: Brightness.light,
                    ),
                  ),
                  darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.purple,
                      brightness: Brightness.dark,
                    ),
                  ),
                  initialRoute: initRoute,
                  routes: {
                    TasksScreen.routeName: (context) => const TasksScreen(),
                    App.routeName: (context) => const App(),
                    AboutScreen.routeName: (context) => const AboutScreen(),
                    Statistics.routeName: ((context) => const Statistics()),
                    ArchiveRoutinesScreen.routeName: ((context) =>
                        const ArchiveRoutinesScreen()),
                    OnBoarding.routeName: (((context) => const OnBoarding()))
                  }),
            ),
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              body: Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ),
          )),
        );
      },
    );
  }
}
