import './home_automation.dart';

void main() {
  runApp(const HomeAutomation());
  Bloc.observer = GlobalBlocObserver();
}
