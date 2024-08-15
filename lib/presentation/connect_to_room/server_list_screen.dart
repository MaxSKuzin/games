import 'package:auto_route/auto_route.dart';
import 'package:bang/injection.dart';
import 'package:bang/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_network_room/local_network_room.dart';

@RoutePage()
class ServerListScreen extends StatefulWidget {
  const ServerListScreen({super.key});

  @override
  State<ServerListScreen> createState() => _ServerListScreenState();
}

class _ServerListScreenState extends State<ServerListScreen> {
  final _listsCubit = getIt<ServersListCubit>()..getList();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _listsCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _listsCubit,
      child: BlocListener<ServerConnectCubit, ServerConnectState>(
        listener: (context, state) => state.maybeMap(
          connected: (value) => context.replaceRoute(
            GameStartPendingRoute(
              clientInfo: value.clientInfo,
              server: value.server,
            ),
          ),
          orElse: () => null,
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: context.maybePop,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Player name',
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ServersListCubit, ServersListState>(
                      builder: (context, state) => state.map(
                        initial: (value) => const SizedBox(),
                        loading: (value) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        ready: (value) => RefreshIndicator(
                          onRefresh: _listsCubit.getList,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final room = value.servers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Material(
                                    child: BlocBuilder<ServerConnectCubit,
                                        ServerConnectState>(
                                      builder: (context, state) => InkWell(
                                        onTap: state.maybeWhen(
                                          disconnected: () => () => context
                                              .read<ServerConnectCubit>()
                                              .connect(
                                                server: room,
                                                playerName:
                                                    _nameController.text,
                                              ),
                                          orElse: () => null,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              room.name,
                                            ),
                                            Text(
                                              room.players.length.toString(),
                                            ),
                                            Text(
                                              room.ip,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: value.servers.length,
                          ),
                        ),
                        error: (value) => Column(
                          children: [
                            Text(value.error.toString()),
                            TextButton(
                              onPressed: _listsCubit.getList,
                              child: const Text(
                                'Retry',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
