import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: StartRoute.page,
          initial: true,
          transitionsBuilder: TransitionsBuilders.fadeIn,
        ),
        CustomRoute(
          page: CreateRoomFlow.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          children: [
            CustomRoute(
              page: CreateRoomRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              initial: true,
            ),
            CustomRoute(
              page: StartGameRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              page: TicTacToeGameRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
          ],
        ),
        CustomRoute(
          page: ConnectToRoomFlow.page,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          children: [
            CustomRoute(
              page: ServerListRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              initial: true,
            ),
            CustomRoute(
              page: GameStartPendingRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              page: TicTacToeGameRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
          ],
        ),
      ];
}
