import 'package:get/get.dart';
import 'package:sparky/features/conduit/presentation/screen/conduit_screen.dart';

import '../../features/disclaimer/presentation/screen/disclaimer_screen.dart';
import '../../features/dwelling/presentation/screen/dwelling_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/moto/presentation/screen/motor_screen.dart';
import '../../features/notifications/presentation/screen/notifications_screen.dart';
import '../../features/ohm/presentation/screen/ohm_screen.dart';
import '../../features/solar/presentation/screen/solar_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/transeformer/presentation/screen/transeformer_screen.dart';
import '../../features/transforme/presentation/screen/transforme_screen.dart';
import '../../features/voltage/presentation/screen/voltage_screen.dart';
import '../../features/wire/presentation/screen/wire_screen.dart';

class AppRoutes {
  static const String test = '/test_screen.dart';
  static const String splash = '/';
  static const String notifications = '/notifications_screen.dart';
  static const String home = '/home_screen.dart';
  static const String ohm = '/ohm_screen.dart';
  static const String motor = '/motor_screen.dart';
  static const String transform = '/transform_screen.dart';
  static const String wire = '/wire_screen.dart';
  static const String conduit = '/conduit_screen.dart';
  static const String voltage = '/voltage_screen.dart';
  static const String dwelling = '/dwelling_screen.dart';
  static const String transformer = '/transformer_screen.dart';
  static const String solar = '/solar_screen.dart';
  static const String disclaimer = '/disclaimer_screen.dart';

  static List<GetPage<String>> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: notifications, page: () => const NotificationScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: ohm, page: () => const OhmScreen()),
    GetPage(name: motor, page: () => const MotorScreen()),
    GetPage(name: transform, page: () => const TransformScreen()),
    GetPage(name: wire, page: () => const WireScreen()),
    GetPage(name: conduit, page: () => const ConduitScreen()),
    GetPage(name: voltage, page: () => const VoltageScreen()),
    GetPage(name: dwelling, page: () => const DwellingScreen()),
    GetPage(name: transformer, page: () => const TransformerScreen()),
    GetPage(name: solar, page: () => const SolarScreen()),
    GetPage(name: disclaimer, page: () => const DisclaimerScreen()),
  ];
}
