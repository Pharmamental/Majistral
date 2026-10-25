import 'package:flutter/material.dart';

import 'logic/job_store.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await JobStore.load();
  runApp(MajistralApp(store: store));
}

class MajistralApp extends StatelessWidget {
  const MajistralApp({super.key, required this.store});

  final JobStore store;

  @override
  Widget build(BuildContext context) {
    return JobScope(
      store: store,
      child: MaterialApp(
        title: 'Majistral',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
