import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'nodemcu_home_automation_event.dart';

part 'nodemcu_home_automation_state.dart';

part '../service/nodemcu_service.dart';

part '../model/home_automation_model.dart';

Duration _duration = const Duration(milliseconds: 100);

class NodeMCUHomeAutomationBloc
    extends Bloc<NodeMCUHomeAutomationEvent, NodeMCUHomeAutomationState> {
  NodeMCUHomeAutomationBloc() : super((const NodeMCUHomeAutomationState())) {
    on<ConnectToNodeMCU>(
      _connectToNodeMCU,
      transformer: transformer(_duration),
    );
    on<DisconnectFromNodeMCU>(
      _disconnectFromNodeMCU,
      transformer: transformer(_duration),
    );
    on<SendDataToNodeMCU>(
      _sendDataToNodeMCU,
    );
    on<OnDataReceiveFromNodeMCU>(
      _onDataReceiveFromNodeMCU,
    );
  }

  FutureOr<void> _connectToNodeMCU(
      ConnectToNodeMCU event, Emitter<NodeMCUHomeAutomationState> emit) async {
    emit(state.copyWith(
        status: NodeMCUHomeAutomationStatus.connecting,
        webSocket: event.webSocket,
        data: HomeAutomationModel()));
    try {
      await NodeMCUService().initWebSocket(event.webSocket, (data) {
        add(OnDataReceiveFromNodeMCU(data));
      });
      emit(state.copyWith(status: NodeMCUHomeAutomationStatus.connected));
    } catch (e) {
      emit(state.copyWith(
          status: NodeMCUHomeAutomationStatus.error, error: e.toString()));
    }
  }

  FutureOr<void> _disconnectFromNodeMCU(DisconnectFromNodeMCU event,
      Emitter<NodeMCUHomeAutomationState> emit) async {
    await NodeMCUService().closeWebSocket(state.webSocket!);
    emit(state.copyWith(
        status: NodeMCUHomeAutomationStatus.disconnected,
        data: HomeAutomationModel()));
  }

  FutureOr<void> _sendDataToNodeMCU(
      SendDataToNodeMCU event, Emitter<NodeMCUHomeAutomationState> emit) async {
    emit(state.copyWith(sendDataStatus: NodeMCUSendDataStatus.sending));
    try {
      await NodeMCUService().sendToNodeMCU(event.data, state.webSocket!);
      emit(state.copyWith(sendDataStatus: NodeMCUSendDataStatus.sent));
    } catch (e) {
      emit(state.copyWith(
          sendDataStatus: NodeMCUSendDataStatus.error, error: e.toString()));
    }
  }

  FutureOr<void> _onDataReceiveFromNodeMCU(OnDataReceiveFromNodeMCU event,
      Emitter<NodeMCUHomeAutomationState> emit) {
    emit(
      state.copyWith(
          data: state.data!.copyWith(
        relay1: event.data.containsKey('relay1')
            ? event.data['relay1'] == 1
            : state.data!.relay1,
        relay2: event.data.containsKey('relay2')
            ? event.data['relay2'] == 1
            : state.data!.relay2,
        relay3: event.data.containsKey('relay3')
            ? event.data['relay3'] == 1
            : state.data!.relay3,
        relay4: event.data.containsKey('relay4')
            ? event.data['relay4'] == 1
            : state.data!.relay4,
        humidity: event.data.containsKey('humidity')
            ? event.data['humidity']
            : state.data!.humidity,
        temperature: event.data.containsKey('temperature')
            ? event.data['temperature']
            : state.data!.temperature,
      )),
    );
  }
}

EventTransformer<T> transformer<T>(Duration duration) {
  return (events, mapper) {
    return droppable<T>().call(events.throttle(duration), mapper);
  };
}
