import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodemcu_home_automation/bloc/nodemcu_home_automation_bloc.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import "../constants/home_page_constants.dart";

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
              final temp = state.data?.temperature ?? 0.0;
              final tempRemaining = (100.0 - (state.data?.temperature ?? 0));
              final humidity = state.data?.humidity ?? 0.0;
              final humidityRemaining = (100.0 - (state.data?.humidity ?? 0));
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white,
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                  Colors.grey.shade300
                ], stops: [
                  0.1,
                  0.4,
                  0.6,
                  0.8
                ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: _formKey,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: 80,
                              width: 300,
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
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  decoration: textFieldDecoration),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: state.status ==
                                        NodeMCUHomeAutomationStatus.connected
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<
                                                      NodeMCUHomeAutomationBloc>(
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
                                style: elevatedButtonStyle,
                                child: const Text(
                                  'CONNECT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: state.status !=
                                        NodeMCUHomeAutomationStatus.connected
                                    ? null
                                    : () {
                                        BlocProvider.of<
                                                    NodeMCUHomeAutomationBloc>(
                                                context)
                                            .add(const DisconnectFromNodeMCU());
                                      },
                                style: elevatedButtonStyle,
                                child: const Text(
                                  'DISCONNECT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      pieChart(temp, tempRemaining),
                                      Text(
                                        state.data?.temperature != null
                                            ? 'Temperature: ${state.data!.temperature}'
                                            : 'Temperature: 0.0',
                                      )
                                    ])),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      pieChart(humidity, humidityRemaining),
                                      Text(state.data?.humidity != null
                                          ? 'Humidity: ${state.data!.humidity}'
                                          : 'Humidity: 0.0'),
                                    ])),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            color: state.data?.relay1 != false
                                ? Colors.black
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 200,
                          width: 150,
                          duration: Duration(seconds: 1),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Icon(
                                    Icons.light_outlined,
                                    color: state.data?.relay1 != false
                                        ? Colors.white
                                        : Colors.black,
                                    size: 70,
                                  ),
                                ),
                                customCupertinoSwitch(
                                    'Relay1',
                                    state.data?.relay1 ?? false,
                                    (p0) => context
                                        .read<NodeMCUHomeAutomationBloc>()
                                        .add(SendDataToNodeMCU('toggleCh1'))),
                              ]),
                        ),
                      )
                      // Text(
                      //   state.data?.temperature != null
                      //       ? 'Temperature: ${state.data!.temperature}'
                      //       : 'Temperature: 0.0',
                      //   style: TextStyle(color: Colors.black, fontSize: 20),
                      // ),
                      // const SizedBox(height: 20),
                      // Text(
                      //   state.data?.humidity != null
                      //       ? 'Humidity: ${state.data!.humidity}'
                      //       : 'Humidity: 0.0',
                      //   style: TextStyle(color: Colors.black, fontSize: 20),
                      // ),
                      //const SizedBox(height: 20),
                      // customCupertinoSwitch(
                      //     'Relay1',
                      //     state.data?.relay1 ?? false,
                      //     (p0) => context
                      //         .read<NodeMCUHomeAutomationBloc>()
                      //         .add(SendDataToNodeMCU('toggleCh1'))),
                      // customCupertinoSwitch(
                      //     'Relay2',
                      //     state.data?.relay2 ?? false,
                      //     (p0) => context
                      //         .read<NodeMCUHomeAutomationBloc>()
                      //         .add(SendDataToNodeMCU('toggleCh2'))),
                      // customCupertinoSwitch(
                      //     'Relay3',
                      //     state.data?.relay3 ?? false,
                      //     (p0) => context
                      //         .read<NodeMCUHomeAutomationBloc>()
                      //         .add(SendDataToNodeMCU('toggleCh3'))),
                      // customCupertinoSwitch(
                      //     'Relay4',
                      //     state.data?.relay4 ?? false,
                      //     (p0) => context
                      //         .read<NodeMCUHomeAutomationBloc>()
                      //         .add(SendDataToNodeMCU('toggleCh4'))),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget pieChart(double value, double valueRemaining) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          centerSpaceColor: Colors.grey.shade50,
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.black,
              width: 10,
            ),
          ),
          sections: [
            PieChartSectionData(
              color: Colors.black,
              borderSide: BorderSide(
                color: Colors.grey.shade50,
                width: 4,
              ),
              value: value,
              showTitle: false,
              radius: 20,
            ),
            PieChartSectionData(
              color: Colors.grey.shade100,
              borderSide: BorderSide(
                color: Colors.black26,
                width: 4,
              ),
              showTitle: false,
              value: valueRemaining,
              radius: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Widget customCupertinoSwitch(
    String title, bool value, Function(bool) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
          child: Text(
        title,
        maxLines: 2,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
      const SizedBox(width: 20),
      RotatedBox(
        quarterTurns: 1,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

class ChartData {
  final String title;
  final double value;
  ChartData(this.title, this.value);
}
