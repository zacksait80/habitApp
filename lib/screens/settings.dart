import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kodu_ko/screens/about.dart';
import 'package:kodu_ko/screens/archive_routines.dart';
import 'package:kodu_ko/screens/stats.dart';
import 'package:kodu_ko/services/routines_provider.dart';
import 'package:kodu_ko/services/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          Text(
            "Settings",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              textStyle: textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 30),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, ArchiveRoutinesScreen.routeName),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "Archived",
                      child: Text(
                        "Archived",
                        style: textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pushNamed(
                            context, ArchiveRoutinesScreen.routeName),
                        icon: const Icon(Icons.archive_rounded)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, Statistics.routeName),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: "Statistics",
                      child: Text(
                        "Statistics",
                        style: textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, Statistics.routeName),
                        icon: const Icon(Icons.pie_chart)),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () {
                Provider.of<ThemeModel>(context, listen: false).toggleTheme();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: textTheme.titleLarge,
                    ),
                    Consumer<ThemeModel>(
                      builder: (context, value, child) => TextButton.icon(
                          label: value.getTheme == ThemeMode.system
                              ? const Text("System")
                              : value.getTheme == ThemeMode.dark
                                  ? const Text("Dark")
                                  : const Text("Light"),
                          onPressed: () {
                            Provider.of<ThemeModel>(context, listen: false)
                                .toggleTheme();
                          },
                          icon: value.getTheme == ThemeMode.system
                              ? const Icon(Icons.settings)
                              : value.getTheme == ThemeMode.dark
                                  ? const Icon(Icons.dark_mode_rounded)
                                  : const Icon(Icons.light_mode_rounded),),
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () {
                Provider.of<RoutineModel>(context, listen: false)
                    .toggleNotifications();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notifications ",
                      style: textTheme.titleLarge,
                    ),
                    Selector<RoutineModel, bool>(
                      selector: (p0, p1) => p1.notifications,
                      builder: (context, value, child) => TextButton.icon(
                        label: value ? const Text("ON") : const Text("OFF"),
                        onPressed: () {
                          Provider.of<RoutineModel>(context, listen: false)
                              .toggleNotifications();
                        },
                        icon: value
                            ? const Icon(Icons.notifications_active_rounded)
                            : const Icon(Icons.notifications_off_rounded),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AboutScreen.routeName),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "About ",
                      style: textTheme.titleLarge,
                    ),
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AboutScreen.routeName),
                        icon: const Icon(Icons.person)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              "Version: 1.0.0",
              style: textTheme.labelMedium!
                  .apply(color: textTheme.labelMedium!.color!.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              "GROUP 4-B",
              style: textTheme.labelMedium!
                  .apply(color: textTheme.labelMedium!.color!.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
