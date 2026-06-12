import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/solar_controller.dart';
import '../widgets/energy_item.dart';

class SolarScreen extends StatelessWidget {
  const SolarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Solar Panel Calculator',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder<SolarController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Energy Usage History ──────────────────────
                  const CommonText(
                    text: 'Energy Usage History',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    bottom: 12,
                  ),

                  ...List.generate(
                    controller.count,
                        (index) =>
                        EnergyItem(controller: controller, index: index),
                  ),

                  20.height,

                  // Add Another Reading
                  InkWell(
                    onTap: controller.addConductors,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppColors.white),
                          CommonText(
                              text: 'Add Another Reading', left: 10),
                        ],
                      ),
                    ),
                  ),

                  20.height,
                  const Divider(),
                  20.height,

                  // ── System Parameters ─────────────────────────
                  const CommonText(
                    text: 'System Parameters',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    bottom: 20,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          labelText: 'Panel Watts',
                          controller: controller.panelWattsController,
                          keyboardType: TextInputType.number,
                          suffixIcon: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: CommonText(text: 'W', right: 12),
                          ),
                        ),
                      ),
                      12.width,
                      Expanded(
                        child: CommonTextField(
                          controller: controller.peakController,
                          labelText: 'Peak Sun Hours',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  20.height,
                  CommonTextField(
                    controller: controller.secondaryVoltageController,
                    labelText: 'System Loss',
                    keyboardType: TextInputType.number,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: CommonText(text: '%', right: 12),
                    ),
                  ),
                  24.height,

                  // ── Calculate Button ──────────────────────────
                  CommonButton(
                    titleText: 'Calculate Panels',
                    buttonRadius: 30,
                    onTap: controller.calculate,
                  ),

                  // ── Results ───────────────────────────────────
                  if (controller.hasResult) ...[
                    20.height,
                    _buildResultCard(controller),
                  ],

                  20.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Result Card (dark teal style) ───────────────────────────
  Widget _buildResultCard(SolarController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F1F),        // dark background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00BFA5),       // teal border
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // "Recommended System"
          const Text(
            'Recommended System',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF80CBC4),         // light teal
            ),
          ),

          const SizedBox(height: 8),

          // Big panel count
          Text(
            '${controller.panelCountOnly} Panels',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BFA5),         // teal
            ),
          ),

          const Divider(height: 28, color: Color(0xFF1E3A3A)),

          // Average Daily Load
          Text(
            'Average Daily Load: ${controller.totalEnergy}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF80CBC4),
            ),
          ),

          const SizedBox(height: 4),

          // Est. System Size
          Text(
            'Est. System Size: ${controller.systemCapacity}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4DB6AC),
            ),
          ),
        ],
      ),
    );
  }
}