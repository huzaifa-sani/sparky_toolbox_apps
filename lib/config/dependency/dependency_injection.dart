import 'package:get/get.dart';
import 'package:sparky/features/conduit/presentation/controller/conduit_controller.dart';

import '../../features/dwelling/presentation/controller/dwelling_controller.dart';
import '../../features/home/presentation/controller/home_controller.dart';
import '../../features/moto/presentation/controller/motor_controller.dart';
import '../../features/solar/presentation/controller/solar_controller.dart';
import '../../features/transeformer/presentation/controller/transerformer_controller.dart';
import '../../features/transforme/presentation/controller/transform_controller.dart';
import '../../features/voltage/presentation/controller/voltage_controller.dart';
import '../../features/wire/presentation/controller/wire_contrtoller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => MotorController(), fenix: true);
    Get.lazyPut(() => TransformController(), fenix: true);
    Get.lazyPut(() => WireController(), fenix: true);
    Get.lazyPut(() => ConduitController(), fenix: true);
    Get.lazyPut(() => VoltageController(), fenix: true);
    Get.lazyPut(() => DwellingController(), fenix: true);
    Get.lazyPut(() => TransformerController(), fenix: true);
    Get.lazyPut(() => SolarController(), fenix: true);
  }
}
