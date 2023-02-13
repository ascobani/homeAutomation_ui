import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodemcu_home_automation/bloc/nodemcu_home_automation_bloc.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _ipAddressController;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _ipAddressController = TextEditingController();
  }

  @override
  dispose() {
    _ipAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NodeMCUHomeAutomationBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: BlocConsumer<NodeMCUHomeAutomationBloc,
              NodeMCUHomeAutomationState>(
            listener: (context, state) {
              if (state.status == NodeMCUHomeAutomationStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            height: 81,
                            width: 180,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter IP Address';
                                }
                                if (!validator.ip(value)) {
                                  return 'Please enter valid IP Address';
                                }
                                return null;
                              },
                              controller: _ipAddressController,
                              decoration: const InputDecoration(
                                hintText: 'Enter IP Address',
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: state.status ==
                                  NodeMCUHomeAutomationStatus.connected
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<NodeMCUHomeAutomationBloc>(
                                            context)
                                        .add(
                                      ConnectToNodeMCU(
                                        WebSocketChannel.connect(
                                          Uri.parse(
                                              'ws://${_ipAddressController.text}/ws'),
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: const Text('Connect'),
                        ),
                        ElevatedButton(
                            onPressed: state.status !=
                                    NodeMCUHomeAutomationStatus.connected
                                ? null
                                : () {
                                    BlocProvider.of<NodeMCUHomeAutomationBloc>(
                                            context)
                                        .add(
                                      const DisconnectFromNodeMCU(),
                                    );
                                  },
                            child: const Text('Disconnect')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.data?.temperature != null
                          ? 'Temperature: ${state.data!.temperature}'
                          : 'Temperature: 0.0',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.data?.humidity != null
                          ? 'Humidity: ${state.data!.humidity}'
                          : 'Humidity: 0.0',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    customCupertinoSwitch(
                        'Relay1',
                        state.data?.relay1 ?? false,
                        (p0) => context
                            .read<NodeMCUHomeAutomationBloc>()
                            .add(SendDataToNodeMCU('toggleCh1'))),
                    customCupertinoSwitch(
                        'Relay2',
                        state.data?.relay2 ?? false,
                        (p0) => context
                            .read<NodeMCUHomeAutomationBloc>()
                            .add(SendDataToNodeMCU('toggleCh2'))),
                    customCupertinoSwitch(
                        'Relay3',
                        state.data?.relay3 ?? false,
                        (p0) => context
                            .read<NodeMCUHomeAutomationBloc>()
                            .add(SendDataToNodeMCU('toggleCh3'))),
                    customCupertinoSwitch(
                        'Relay4',
                        state.data?.relay4 ?? false,
                        (p0) => context
                            .read<NodeMCUHomeAutomationBloc>()
                            .add(SendDataToNodeMCU('toggleCh4'))),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget customCupertinoSwitch(
    String title, bool value, Function(bool) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(title),
      const SizedBox(width: 20),
      CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}