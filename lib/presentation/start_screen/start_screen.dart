import 'package:auto_route/auto_route.dart';
import 'package:bang/router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.pushRoute(
                const CreateRoomFlow(),
              ),
              child: const Text('Host'),
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(
                const ConnectToRoomFlow(),
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
