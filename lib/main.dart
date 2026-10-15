import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/posts_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/common.dart';

void main() => runApp(const KobimatApp());

class KobimatApp extends StatelessWidget {
  const KobimatApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kobimat',
        debugShowCheckedModeBanner: false,
        theme: kobimatLight,
        darkTheme: kobimatDark,
        themeMode: ThemeMode.system,
        locale: const Locale('tr'),
        supportedLocales: const [Locale('tr'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const _Root(),
      );
}

class _Root extends StatefulWidget {
  const _Root();
  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> {
  bool _signedIn = false;

  @override
  Widget build(BuildContext context) => _signedIn
      ? const HomeShell()
      : LoginScreen(
          // TODO: Supabase.instance.client.auth.signInWithPassword(...)
          onLogin: (email, password) async => Future<void>.delayed(const Duration(milliseconds: 500)),
          onLoggedIn: () => setState(() => _signedIn = true),
        );
}

/// Alt gezinme: Ana sayfa, Gönderiler, Takvim, Daha fazla.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _index, children: const [
          _Soon('Ana sayfa'),
          PostsScreen(),
          _Soon('Takvim'),
          _Soon('Daha fazla'),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana sayfa'),
            NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Gönderiler'),
            NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Takvim'),
            NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Daha fazla'),
          ],
        ),
      );
}

class _Soon extends StatelessWidget {
  const _Soon(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => SafeArea(
        child: StateMessage(icon: Icons.construction_outlined, title: title, message: 'Bu ekran sıradaki tasarım adımında eklenecek.'),
      );
}
