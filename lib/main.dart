import 'package:bang/injection.dart';
import 'package:bang/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_network_room/local_network_room.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNetworkRoom.setup(getIt);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  void dispose() {
    _appRouter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orangeAccent,
        ),
      ),
      title: 'Bitrussia',
      routerConfig: _appRouter.config(),
    );
  }
}
