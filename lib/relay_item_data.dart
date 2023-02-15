import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//page imports
import './model/relay_item_model.dart';
import 'bloc/nodemcu_home_automation_bloc.dart';

List<RelayItemModel> relayData(
    BuildContext context, NodeMCUHomeAutomationState state) {
  return [
    RelayItemModel(
      context: context,
      title: "Relay 1",
      value: state.data?.relay1 ?? false,
      onChanged: (p0) => context
          .read<NodeMCUHomeAutomationBloc>()
          .add(SendDataToNodeMCU('toggleCh1')),
      icon: Icons.light_outlined,
    ),
    RelayItemModel(
      context: context,
      title: "Relay 2",
      value: state.data?.relay2 ?? false,
      onChanged: (p0) => context
          .read<NodeMCUHomeAutomationBloc>()
          .add(SendDataToNodeMCU('toggleCh2')),
      icon: Icons.light_outlined,
    ),
    RelayItemModel(
      context: context,
      title: "Relay 3",
      value: state.data?.relay3 ?? false,
      onChanged: (p0) => context
          .read<NodeMCUHomeAutomationBloc>()
          .add(SendDataToNodeMCU('toggleCh3')),
      icon: Icons.light_outlined,
    ),
    RelayItemModel(
      context: context,
      title: "Relay 4",
      value: state.data?.relay4 ?? false,
      onChanged: (p0) => context
          .read<NodeMCUHomeAutomationBloc>()
          .add(SendDataToNodeMCU('toggleCh4')),
      icon: Icons.flash_on_outlined,
    ),
  ];
}
