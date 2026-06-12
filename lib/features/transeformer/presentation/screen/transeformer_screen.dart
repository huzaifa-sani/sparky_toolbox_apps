import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import '../controller/transerformer_controller.dart';

class TransformerScreen extends StatelessWidget {
  const TransformerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransformerController());

    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Transformer Sizing',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder<TransformerController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Phase Type ────────────────────────────────
                  Row(
                    children: [
                      _PhaseRadio(
                        label: 'Single Phase',
                        selected: controller.selectedPhase == 'single',
                        onTap: () => controller.setPhase('single'),
                      ),
                      20.width,
                      _PhaseRadio(
                        label: 'Three Phase',
                        selected: controller.selectedPhase == 'three',
                        onTap: () => controller.setPhase('three'),
                      ),
                    ],
                  ),

                  20.height,

                  // ── Secondary Voltage ─────────────────────────
                  CommonTextField(
                    labelText: 'Secondary Voltage (V)',
                    controller: controller.secVoltageController,
                    keyboardType: TextInputType.number,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4, bottom: 16),
                    child: Text(
                      'Note: Use the secondary (load) voltage for sizing.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),
                  ),

                  // ── Load Inputs label ─────────────────────────
                  const CommonText(
                    text: 'Load Inputs',
                    fontWeight: FontWeight.w600,
                    bottom: 12,
                  ),

                  // ── Load Rows ─────────────────────────────────
                  ...List.generate(controller.loadRows.length, (index) {
                    final row = controller.loadRows[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CommonTextField(
                                  labelText: 'Amps',
                                  controller: row.loadAmpsController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              12.width,
                              Expanded(
                                flex: 2,
                                child: CommonTextField(
                                  labelText: 'Qty',
                                  controller: row.qtyController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              if (controller.loadRows.length > 1) ...[
                                8.width,
                                GestureDetector(
                                  onTap: () =>
                                      controller.removeLoadRow(index),
                                  child: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Color(0xFFC0556E),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          8.height,
                          // Continuous Load checkbox
                          GestureDetector(
                            onTap: () =>
                                controller.toggleContinuous(index),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white54,
                                        width: 1.5),
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    color: row.isContinuous
                                        ? const Color(0xFFC0556E)
                                        : Colors.transparent,
                                  ),
                                  child: row.isContinuous
                                      ? const Icon(Icons.check,
                                      size: 14,
                                      color: Colors.white)
                                      : null,
                                ),
                                8.width,
                                const Text(
                                  'Continuous Load (Calculated @ 125%)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  InkWell(
                    onTap: controller.addLoadRow,
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Color(0xFFC0556E)),
                          SizedBox(width: 8),
                          Text(
                            'Add Another Load',
                            style: TextStyle(
                              color: Color(0xFFC0556E),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  20.height,
                  const Divider(color: Colors.white12),
                  16.height,

                  // ── Formula Note ──────────────────────────────
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1F1F),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: const Color(0xFF00BFA5), width: 1),
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF80CBC4),
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Formula: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BFA5),
                            ),
                          ),
                          TextSpan(
                            text: controller.selectedPhase == 'single'
                                ? 'kVA = (Total A × V) ÷ 1000\n'
                                : 'kVA = (Total A × V × √3) ÷ 1000\n',
                          ),
                          const TextSpan(
                              text: 'Continuous loads multiplied by '),
                          const TextSpan(
                            text: '1.25 (125%)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                  24.height,

                  // ── Calculate Button ──────────────────────────
                  CommonButton(
                    titleText: 'Calculate Size',
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

  // ── Result card (dark teal style) ─────────────────────────────
  Widget _buildResultCard(TransformerController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00BFA5), width: 1.5),
      ),
      child: Column(
        children: [
          const Text(
            'Recommended Transformer',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF80CBC4),
            ),
          ),
          8.height,
          Text(
            controller.standardSize,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: Color(0xFF00BFA5),
            ),
          ),
          const Divider(height: 24, color: Color(0xFF1E3A3A)),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Calculated Load',
                  value: controller.calculatedLoad,
                ),
              ),
              12.width,
              Expanded(
                child: _MetricTile(
                  label: 'Required kVA',
                  value: controller.requiredKva,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Phase Radio ────────────────────────────────────────────────
class _PhaseRadio extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PhaseRadio({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? const Color(0xFFC0556E)
                    : Colors.white54,
                width: 2,
              ),
            ),
            child: selected
                ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC0556E),
                ),
              ),
            )
                : null,
          ),
          8.width,
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Metric Tile ────────────────────────────────────────────────
class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5).withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFF00BFA5).withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF80CBC4),
            ),
          ),
          6.height,
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF00BFA5),
            ),
          ),
        ],
      ),
    );
  }
}

extension _Spacing on num {
  Widget get height => SizedBox(height: toDouble());
  Widget get width => SizedBox(width: toDouble());
}