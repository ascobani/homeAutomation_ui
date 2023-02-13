part of '../bloc/nodemcu_home_automation_bloc.dart';

class HomeAutomationModel {
  bool relay1;
  bool relay2;
  bool relay3;
  bool relay4;

  double temperature;
  double humidity;

  HomeAutomationModel({
    this.relay1 = false,
    this.relay2 = false,
    this.relay3 = false,
    this.relay4 = false,
    this.temperature = 0.0,
    this.humidity = 0.0,
  });

  copyWith({
    bool? relay1,
    bool? relay2,
    bool? relay3,
    bool? relay4,
    double? temperature,
    double? humidity,
  }) {
    return HomeAutomationModel(
      relay1: relay1 ?? this.relay1,
      relay2: relay2 ?? this.relay2,
      relay3: relay3 ?? this.relay3,
      relay4: relay4 ?? this.relay4,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
    );
  }

  Map<String ,dynamic> toJson() {
    return {
      'relay1': relay1,
      'relay2': relay2,
      'relay3': relay3,
      'relay4': relay4,
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}
