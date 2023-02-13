part of 'nodemcu_home_automation_bloc.dart';

enum NodeMCUHomeAutomationStatus { connecting, connected, disconnected, error }

enum NodeMCUSendDataStatus { initial, sending, sent, error }

class NodeMCUHomeAutomationState extends Equatable {
  const NodeMCUHomeAutomationState({
    this.status = NodeMCUHomeAutomationStatus.disconnected,
    this.sendDataStatus = NodeMCUSendDataStatus.initial,
    this.webSocket,
    this.error,
    this.data,
  });

  final NodeMCUHomeAutomationStatus status;
  final NodeMCUSendDataStatus sendDataStatus;
  final String? error;
  final HomeAutomationModel? data;
  final WebSocketChannel? webSocket;

  @override
  List<Object?> get props => [status, error, data, sendDataStatus, webSocket];

  @override
  toString() =>
      'NodeMCUHomeAutomationState { status: $status, sendDataStatus: $sendDataStatus, data: $data, error: $error }';

  NodeMCUHomeAutomationState copyWith({
    NodeMCUHomeAutomationStatus? status,
    NodeMCUSendDataStatus? sendDataStatus,
    HomeAutomationModel? data,
    String? error,
    WebSocketChannel? webSocket,
  }) {
    return NodeMCUHomeAutomationState(
      status: status ?? this.status,
      sendDataStatus: sendDataStatus ?? this.sendDataStatus,
      data: data ?? this.data,
      error: error ?? this.error,
      webSocket: webSocket ?? this.webSocket,
    );
  }
}
