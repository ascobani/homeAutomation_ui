part of 'nodemcu_home_automation_bloc.dart';

abstract class NodeMCUHomeAutomationEvent extends Equatable {
  const NodeMCUHomeAutomationEvent();
}

class ConnectToNodeMCU extends NodeMCUHomeAutomationEvent {
  final WebSocketChannel webSocket;

  const ConnectToNodeMCU(this.webSocket);

  @override
  List<Object?> get props => [webSocket];

  @override
  toString() => 'ConnectToNodeMCU { ip: $webSocket }';
}

class DisconnectFromNodeMCU extends NodeMCUHomeAutomationEvent {
  const DisconnectFromNodeMCU();

  @override
  List<Object?> get props => [];

  @override
  toString() => 'DisconnectFromNodeMCU';
}

class SendDataToNodeMCU extends NodeMCUHomeAutomationEvent {
  final String data;

  const SendDataToNodeMCU(this.data);

  @override
  List<Object?> get props => [data];

  @override
  toString() => 'SendDataToNodeMCU { data: $data }';
}

class OnDataReceiveFromNodeMCU extends NodeMCUHomeAutomationEvent {
  final Map<String, dynamic> data;

  const OnDataReceiveFromNodeMCU(this.data);

  @override
  List<Object?> get props => [data];

  @override
  toString() => 'OnDataReceiveFromNodeMCU { data: $data }';
}
