import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/pop_up/common_pop_menu.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/voltage_controller.dart';

class VoltageScreen extends StatelessWidget {
  const VoltageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Voltage Drop',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder<VoltageController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CommonTextField(
                    hintText: 'Supply Voltage (V)',
                    controller: controller.supplyVoltageController,
                    keyboardType: TextInputType.number,
                  ),
                  20.height,
                  CommonTextField(
                    hintText: 'Load Amps',
                    controller: controller.loadAmpsController,
                    keyboardType: TextInputType.number,
                  ),
                  20.height,
                  CommonTextField(
                    hintText: 'Distance One-Way (ft)',
                    controller: controller.distanceController,
                    keyboardType: TextInputType.number,
                  ),

                  // ── Material & Phase ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(
                              text: 'Material',
                              top: 12,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            ...List.generate(controller.material.length, (index) {
                              final item = controller.material[index];
                              return Row(
                                children: [
                                  Radio<String>(
                                    value: item,
                                    groupValue: controller.selectMaterial,
                                    onChanged: controller.onChangeMaterial,
                                    fillColor: WidgetStateProperty.all(AppColors.white),
                                  ),
                                  CommonText(text: item),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CommonText(
                              text: 'Phase',
                              top: 12,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            ...List.generate(controller.phase.length, (index) {
                              final item = controller.phase[index];
                              return Row(
                                children: [
                                  Radio<String>(
                                    value: item,
                                    groupValue: controller.selectPhase,
                                    onChanged: controller.onChangePhase,
                                    fillColor: WidgetStateProperty.all(AppColors.white),
                                  ),
                                  CommonText(text: item),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const CommonText(
                    text: 'Conductor Type',
                    top: 20,
                    bottom: 20,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    spacing: 120.w,
                    children: List.generate(controller.conductorType.length, (index) {
                      final item = controller.conductorType[index];
                      // ✅ FIXED: Solid disabled for #6 AWG and larger
                      final bool isSolidOption = item == 'Solid';
                      final bool disabled =
                          isSolidOption && controller.isStrandedOnly;
                      return Row(
                        children: [
                          Radio<String>(
                            value: item,
                            groupValue: controller.selectConductor,
                            // null onChanged = disabled (Kotlin behavior)
                            onChanged: disabled
                                ? null
                                : controller.onChangeConductor,
                            fillColor: WidgetStateProperty.resolveWith((states) {
                              if (disabled) return Colors.grey;
                              return AppColors.white;
                            }),
                          ),
                          CommonText(
                            text: item,
                            color: disabled ? Colors.grey : Colors.white,
                          ),
                        ],
                      );
                    }),
                  ),
                  10.height,

                  // ── Conductor Size ────────────────────────────
                  CommonTextField(
                    hintText: 'Conductor Size',
                    controller: controller.sizeController,
                    readOnly: true,
                    suffixIcon: PopUpMenu(
                      items: controller.size,
                      selectedItem: [controller.sizeController.text],
                      onTap: controller.onChangeSize,
                    ),
                  ),

                  24.height,

                  // ── Error ─────────────────────────────────────
                  if (controller.errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: Colors.red.withOpacity(0.4)),
                      ),
                      child: CommonText(
                        text: controller.errorMessage!,
                        fontSize: 13,
                        color: Colors.redAccent,
                      ),
                    ),
                    12.height,
                  ],

                  // ── Button ────────────────────────────────────
                  CommonButton(
                    titleText: 'Calculate Voltage Drop',
                    buttonRadius: 30,
                    onTap: controller.calculate,
                  ),

                  // ── Result ────────────────────────────────────
                  if (controller.result != null) ...[
                    20.height,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _resultColor(controller.result!.percentage)
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _resultColor(controller.result!.percentage)
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text:
                            'Voltage Drop: ${controller.result!.voltageDrop.toStringAsFixed(2)} V',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _resultColor(controller.result!.percentage),
                          ),
                          8.height,
                          CommonText(
                            text:
                            'Percentage: ${controller.result!.percentage.toStringAsFixed(2)} %',
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          4.height,
                          CommonText(
                            text:
                            'Resistance: ${controller.result!.resistance} Ω/kft',
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          12.height,
                          CommonText(
                            text: controller.result!.percentage <= 3
                                ? '✓ Within 3%'
                                : controller.result!.percentage <= 5
                                ? '⚠ Within 5% max — consider larger wire'
                                : '✗ Exceeds 5% — use larger wire size',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _resultColor(controller.result!.percentage),
                          ),
                        ],
                      ),
                    ),
                    24.height,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _resultColor(double percentage) {
    if (percentage <= 3) return Colors.green;
    if (percentage <= 5) return Colors.orange;
    return Colors.red;
  }
}