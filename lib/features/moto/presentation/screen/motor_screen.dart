import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/pop_up/common_pop_menu.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import 'package:sparky/utils/extensions/extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/motor_controller.dart';
import '../widgets/motor_results.dart';

class MotorScreen extends StatelessWidget {
  const MotorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: 'Motor OCPD & Wire Size',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        body: GetBuilder<MotorController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
                  Row(
                    children: List.generate(controller.phaseOptions.length, (index) {
                      final phaseValue = controller.phaseOptions[index];
                      final phaseLabel = index == 0 ? '1Ø' : index == 1 ? '2Ø' : '3Ø';
                      return Row(
                        children: [
                          Radio<String>(
                            value: phaseValue,
                            groupValue: controller.selectedPhase,
                            fillColor: WidgetStateProperty.all(AppColors.white),
                            onChanged: (v) {
                              if (v != null) controller.onPhaseChange(v);
                            },
                          ),
                          CommonText(
                            text: phaseLabel,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      );
                    }),
                  ),
      
                  16.height,
      
                  // ── Horsepower Dropdown ───────────────────────────
                  CommonTextField(
                    hintText: 'HorsePower (HP)',
                    controller: TextEditingController(text: controller.selectedHpDisplay),
                    readOnly: true,
                    suffixIcon: PopUpMenu(
                      items: controller.hpDisplayList,
                      selectedItem: [controller.selectedHpDisplay],
                      onTap: controller.onSelectHp,
                    ),
                  ),
      
                  20.height,
      
                  // ── Voltage Dropdown ──────────────────────────────
                  CommonTextField(
                    hintText: 'Voltage',
                    controller: TextEditingController(text: controller.selectedVoltage),
                    readOnly: true,
                    suffixIcon: PopUpMenu(
                      items: controller.voltageOptions,
                      selectedItem: [controller.selectedVoltage],
                      onTap: controller.onSelectVoltage,
                    ),
                  ),
      
                  24.height,
      
                  if (controller.errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.4)),
                      ),
                      child: CommonText(
                        text: controller.errorMessage!,
                        fontSize: 13,
                        color: Colors.redAccent,
                      ),
                    ),
                    12.height,
                  ],
      
                  CommonButton(
                    titleText: 'Calculate',
                    buttonRadius: 30,
                    onTap: controller.calculate,
                  ),
                  20.height,
      
                  // ── Results ───────────────────────────────────────
                  const MotorResults(),
      
                  16.height,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}