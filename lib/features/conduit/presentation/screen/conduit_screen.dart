import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/pop_up/common_pop_menu.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/conduit_controller.dart';
import '../widgets/conductors.dart';

class ConduitScreen extends StatelessWidget {
  const ConduitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Conduit Fill',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder<ConduitController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Conduit Type ──────────────────────────────────
                  CommonTextField(
                    controller: controller.conduitTypeController,
                    labelText: 'Conduit Type',
                    readOnly: true,
                    suffixIcon: PopUpMenu(
                      items: controller.conduitType,
                      selectedItem: [controller.conduitTypeController.text],
                      onTap: controller.onChangeConduitType,
                    ),
                  ),
                  20.height,

                  // ── Conduit Size ──────────────────────────────────
                  CommonTextField(
                    controller: controller.conduitSizeController,
                    labelText: 'Conduit Size',
                    readOnly: true,
                    suffixIcon: PopUpMenu(
                      items: controller.conduitSize,
                      selectedItem: [controller.conduitSizeController.text],
                      onTap: controller.onChangeConduitSize,
                    ),
                  ),

                  // ── Conductors List ───────────────────────────────
                  const CommonText(text: 'Add Conductors', top: 20, bottom: 10),
                  ...List.generate(
                    controller.count,
                        (index) => Conductors(index: index),
                  ),
                  20.height,

                  // ── Add Wire Button ───────────────────────────────
                  InkWell(
                    onTap: controller.addConductors,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: AppColors.white),
                          CommonText(text: 'Add Wire Type', left: 4),
                        ],
                      ),
                    ),
                  ),

                  20.height,

                  // ── Error ─────────────────────────────────────────
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

                  // ── Calculate Button ──────────────────────────────
                  CommonButton(
                    titleText: 'Calculate Fill',
                    buttonRadius: 30,
                    onTap: controller.calculate,
                  ),

                  // ── Result ────────────────────────────────────────
                  if (controller.result != null) ...[
                    20.height,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: controller.result!.exceedsLimit
                            ? Colors.red.withOpacity(0.08)
                            : Colors.green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: controller.result!.exceedsLimit
                              ? Colors.red.withOpacity(0.3)
                              : Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText(
                            text: 'Total Conduit Fill',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          8.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CommonText(
                                text: controller.result!.fillPercent
                                    .toStringAsFixed(1),
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: controller.result!.exceedsLimit
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              const CommonText(
                                text: ' %',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                                bottom: 8,
                              ),
                            ],
                          ),
                          CommonText(
                            text: controller.result!.exceedsLimit
                                ? 'Exceeds Limit'
                                : 'Within Limit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: controller.result!.exceedsLimit
                                ? Colors.red
                                : Colors.green,
                          ),
                          16.height,
                          _InfoRow(
                            label: 'Wire Area Total',
                            value:
                            '${controller.result!.totalWireArea.toStringAsFixed(4)} in²',
                          ),
                          8.height,
                          _InfoRow(
                            label: 'Conduit Area',
                            value:
                            '${controller.result!.conduitArea.toStringAsFixed(4)} in²',
                          ),
                          8.height,
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
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(text: label, fontSize: 13, color: Colors.grey),
        CommonText(
            text: value, fontSize: 13, fontWeight: FontWeight.w600),
      ],
    );
  }
}