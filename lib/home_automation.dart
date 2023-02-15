import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './screens/home_screen.dart';
import 'screens/home_screen.dart';
import './bloc/nodemcu_home_automation_bloc.dart';
export './observer/global_bloc_observer.dart';
export 'package:flutter/cupertino.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:nodemcu_home_automation/bloc/nodemcu_home_automation_bloc.dart';
export 'package:regexed_validator/regexed_validator.dart';
export 'package:web_socket_channel/web_socket_channel.dart';

class HomeAutomation extends StatelessWidget {
  const HomeAutomation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NodeMCUHomeAutomationBloc(),
      child: MaterialApp(
        title: 'NodeMCU Home Automation Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(title: 'NodeMCU Home Automation Demo'),
      ),
    );
  }
}
