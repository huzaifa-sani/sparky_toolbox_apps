import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/pop_up/common_pop_menu.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/wire_contrtoller.dart';

class WireScreen extends StatelessWidget {
  const WireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Ampacity Finder',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GetBuilder<WireController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: List.generate(controller.finder.length, (index) {
                    final item = controller.finder[index];
                    return Row(
                      children: [
                        Radio<String>(
                          value: item,
                          groupValue: controller.finderController.text,
                          onChanged: controller.onChangeFinder,
                          fillColor: WidgetStateProperty.all(AppColors.white),
                        ),
                        CommonText(text: item, fontWeight: FontWeight.w500),
                      ],
                    );
                  }),
                ),

                16.height,

                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        readOnly: true,
                        controller: controller.sizeController,
                        labelText: 'Size',
                        suffixIcon: PopUpMenu(
                          items: controller.size,
                          selectedItem: [controller.sizeController.text],
                          onTap: controller.onChangeSize,
                        ),
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: CommonTextField(
                        controller: controller.insulRatingController,
                        readOnly: true,
                        labelText: 'Insul. Rating',
                        suffixIcon: PopUpMenu(
                          items: controller.insulRating,
                          selectedItem: [controller.insulRatingController.text],
                          onTap: controller.onChangeInsulRating,
                        ),
                      ),
                    ),
                  ],
                ),

                20.height,

                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        controller: controller.ambientTempController,
                        labelText: 'Ambient Temp',
                        readOnly: true,
                        suffixIcon: PopUpMenu(
                          items: controller.ambientTempDisplay,
                          selectedItem: [controller.ambientTempController.text],
                          onTap: controller.onChangeAmbientTemp,
                        ),
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: CommonTextField(
                        controller: controller.conductorCountController,
                        labelText: 'Conductor Count',
                        readOnly: true,
                        suffixIcon: PopUpMenu(
                          items: controller.conductorCountDisplay,
                          selectedItem: [controller.conductorCountController.text],
                          onTap: controller.onChangeConductorCount,
                        ),
                      ),
                    ),
                  ],
                ),

                20.height,

                CommonTextField(
                  controller: controller.breakerTempLimitController,
                  labelText: 'Breaker Temp. Limit',
                  readOnly: true,
                  suffixIcon: PopUpMenu(
                    items: controller.breakerTempLimit,
                    selectedItem: [controller.breakerTempLimitController.text],
                    onTap: controller.onChangeBreakerTempLimit,
                  ),
                ),

                20.height,

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

                CommonButton(
                  titleText: 'Calculate Ampacity',
                  buttonRadius: 30,
                  onTap: controller.calculate,
                ),

                if (controller.result != null) ...[
                  20.height,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.white.withOpacity(0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ResultRow(
                          index: '1',
                          label: 'Insulation Base Ampacity',
                          value: controller.result!.insulationBaseAmpacity,
                        ),
                        12.height,
                        _ResultRow(
                          index: '2',
                          label: 'Ambient Correction Factor',
                          value: controller.result!.correctionFactor,
                          isHighlighted: true,
                        ),
                        12.height,
                        _ResultRow(
                          index: '3',
                          label: 'Derated Ampacity',
                          value: controller.result!.deratedAmpacity,
                        ),
                        12.height,
                        _ResultRow(
                          index: '4',
                          label: 'Terminal-Limited Ampacity',
                          value: controller.result!.terminalLimitedAmpacity,
                        ),
                        12.height,
                        Center(
                          child: Text(
                            "OCPD Size",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        12.height,
                        _ResultRow(
                          index: '5',
                          label: 'Down to Next Standard OCPD',
                          value: controller.result!.ocpdDown,
                        ),
                        12.height,
                        _ResultRow(
                          index: '6',
                          label: 'Up to Next Standard OCPD',
                          value: controller.result!.ocpdUp,
                        ),
                        12.height,
                        CommonText(
                          textAlign: TextAlign.start,
                          maxLines: 10,
                          text: 'Note: ${controller.result!.note}',
                          fontSize: 12,
                          color: AppColors.white.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  24.height,
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String index;
  final String label;
  final String value;
  final bool isHighlighted;

  const _ResultRow({
    required this.index,
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: '$index. ',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isHighlighted ? const Color(0xFFF59E0B) : AppColors.white,
        ),
        Expanded(
          child: CommonText(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? const Color(0xFFF59E0B) : AppColors.white,
          ),
        ),
        CommonText(
          text: value,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isHighlighted ? const Color(0xFFF59E0B) : AppColors.white,
        ),
      ],
    );
  }
}
