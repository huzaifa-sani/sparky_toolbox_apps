import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/transform_controller.dart';

class TransformScreen extends StatelessWidget {
  const TransformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Transformer OCPD',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder<TransformController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CommonTextField(
                    labelText: 'Transformer kVA',
                    controller: controller.kvaController,
                    keyboardType: TextInputType.number,
                  ),

                  // ✅ নতুন: over limit হলে লাল, না হলে সাদা/ধূসর
                  if (controller.equipmentLimitLabel.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 4),
                      child: Text(
                        controller.equipmentLimitLabel,
                        style: TextStyle(
                          fontSize: 12,
                          color: controller.isOverLimit
                              ? Colors.redAccent
                              : AppColors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  12.height,

                  CommonTextField(
                    labelText: 'Primary Voltage (Max 600V)',
                    controller: controller.primaryVoltageController,
                    keyboardType: TextInputType.number,
                  ),
                  12.height,

                  CommonTextField(
                    labelText: 'Secondary Voltage (Max 600V)',
                    controller: controller.secondaryVoltageController,
                    keyboardType: TextInputType.number,
                  ),

                  // ── System Phase ───────────────────────────────
                  const CommonText(
                    text: 'System Phase',
                    top: 16,
                    bottom: 8,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  Row(
                    children: List.generate(controller.phase.length, (index) {
                      final item = controller.phase[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: item,
                              groupValue: controller.selectPhase,
                              onChanged: controller.onChangePhase,
                              fillColor: WidgetStateProperty.all(AppColors.white),
                            ),
                            CommonText(text: item, fontWeight: FontWeight.w500),
                          ],
                        ),
                      );
                    }),
                  ),

                  // ── Protection Method ──────────────────────────
                  const CommonText(
                    text: 'Protection Method',
                    top: 16,
                    bottom: 8,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  ...List.generate(controller.method.length, (index) {
                    final item = controller.method[index];
                    return Row(
                      children: [
                        Radio<String>(
                          value: item,
                          groupValue: controller.selectMethod,
                          onChanged: controller.onChangeMethod,
                          fillColor: WidgetStateProperty.all(AppColors.white),
                        ),
                        CommonText(text: item, fontWeight: FontWeight.w500),
                      ],
                    );
                  }),

                  20.height,

                  // ── Over Limit Warning ─────────────────────────
                  // ✅ নতুন: limit exceed হলে warning দেখাবে
                  if (controller.isOverLimit) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.4)),
                      ),
                      child: const Text(
                        'kVA exceeds the equipment limit. Please reduce the kVA value.',
                        style: TextStyle(fontSize: 13, color: Colors.redAccent),
                      ),
                    ),
                    12.height,
                  ],

                  // ── Error ──────────────────────────────────────
                  if (controller.errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
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

                  // ── Calculate Button ───────────────────────────
                  // ✅ নতুন: isOverLimit হলে button disable
                  CommonButton(
                    titleText: controller.isLoading
                        ? 'Calculating...'
                        : 'Calculate Protection Data',
                    buttonHeight: 52,
                    buttonRadius: 30,
                    onTap: (controller.isLoading || controller.isOverLimit)
                        ? null
                        : controller.calculate,
                  ),

                  if (controller.isLoading) ...[
                    20.height,
                    const Center(child: CircularProgressIndicator()),
                  ],

                  // ── Inline Results ─────────────────────────────
                  if (controller.result != null) ...[
                    20.height,
                    _buildResultCard(controller),
                  ],

                  16.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(TransformController controller) {
    final r = controller.result!;
    final isPrimaryOnly =
        controller.selectMethod == 'Primary Only Protection';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00BFA5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calculation Results',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF80CBC4))),
          const Divider(height: 20, color: Color(0xFF1E3A3A)),

          // ── PRIMARY SIDE ───────────────────────────────────
          const Text('PRIMARY SIDE',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BFA5),
                  letterSpacing: 0.6)),
          const SizedBox(height: 10),
          _row('Full Load Amps', '${r.primaryFLA} A'),
          _boldRow('Inverse-Time Breaker', r.primaryOCPD),
          _boldRow('Time-Delay Fuse', r.primaryFuse),
          _row('Wire Size (Cu 75°C)', r.primaryWireSize),

          // ── SECONDARY SIDE ─────────────────────────────────
          if (!isPrimaryOnly) ...[
            const SizedBox(height: 10),
            const Text('SECONDARY SIDE',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5),
                    letterSpacing: 0.6)),
            const SizedBox(height: 10),
            _row('Full Load Amps', '${r.secondaryFLA} A'),
            _boldRow('Inverse-Time Breaker', r.secondaryOCPD),
            _boldRow('Time-Delay Fuse', r.secondaryFuse),
            _row('Wire Size (Cu 75°C)', r.secondaryWireSize),
          ],

          const Divider(height: 20, color: Color(0xFF1E3A3A)),

          // ── SYSTEM GROUNDING ──────────────────────────────────
          const Text('SYSTEM GROUNDING',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BFA5),
                  letterSpacing: 0.6)),
          const SizedBox(height: 10),
          _boldRow('Min. Grounding Wire (EGC) :', '${r.unifiedECG} Cu'),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              'Note: Sized to the largest OCPD in the system (${r.maxOCPD} A).',
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF4DB6AC), height: 1.5),
            ),
          ),

          const Divider(height: 20, color: Color(0xFF1E3A3A)),

          _noteSection('Equipment Note:', r.equipmentNote),
          const SizedBox(height: 12),
          _noteSection('Note:', r.ruleNote),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(children: [
      Expanded(child: Text(label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF80CBC4)))),
      Text(value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF80CBC4))),
    ]),
  );

  Widget _boldRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(children: [
      Expanded(child: Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white))),
      Text(value,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
    ]),
  );

  Widget _accentRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(children: [
      Expanded(child: Text(label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF00BFA5)))),
      Text(value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF00BFA5))),
    ]),
  );

  Widget _noteSection(String title, String body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF00BFA5))),
      const SizedBox(height: 3),
      Text(body,
          style: const TextStyle(
              fontSize: 12, color: Color(0xFF4DB6AC), height: 1.5)),
    ],
  );
}