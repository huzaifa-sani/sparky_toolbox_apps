import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../component/text_field/common_text_field.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/extensions/extension.dart';
import '../controller/solar_controller.dart';

class EnergyItem extends StatelessWidget {
  const EnergyItem({
    super.key,
    required this.controller,
    required this.index,
  });

  final SolarController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CommonTextField(
              labelText: 'Usage (kWh)',
              fillColor: AppColors.background,
              controller: controller.usageControllers[index],
              keyboardType: TextInputType.number,
            ),
          ),
          12.width,
          Expanded(
            child: CommonTextField(
              labelText: 'Days',
              fillColor: AppColors.background,
              controller: controller.daysControllers[index],
              keyboardType: TextInputType.number,
            ),
          ),
          // ✅ FIXED: pass index so correct row is removed
          if (controller.count > 1)
            IconButton(
              onPressed: () => controller.removeConductors(index),
              icon: const Icon(Icons.delete, color: AppColors.red),
            ),
        ],
      ),
    );
  }
}