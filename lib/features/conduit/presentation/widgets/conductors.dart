import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/pop_up/common_pop_menu.dart';
import '../../../../component/text_field/common_text_field.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/extensions/extension.dart';
import '../controller/conduit_controller.dart';

class Conductors extends StatelessWidget {
  final int index;
  const Conductors({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final con   = Get.find<ConduitController>();
    final entry = con.conductors[index];

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CommonTextField(
                  labelText: 'Insulation',
                  fillColor: AppColors.background,
                  controller: entry.insulationController,
                  readOnly: true,
                  suffixIcon: PopUpMenu(
                    items: con.insulation,
                    selectedItem: [entry.insulationController.text],
                    onTap: (i) {
                      entry.insulationController.text = con.insulation[i];
                      con.update();
                    },
                  ),
                ),
              ),
              // ✅ FIXED: only show remove when count > 1 (exact Kotlin)
              if (con.count > 1)
                IconButton(
                  onPressed: () => con.removeConductors(index),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.red,
                  ),
                ),
            ],
          ),
          12.height,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CommonTextField(
                  labelText: 'Size',
                  fillColor: AppColors.background,
                  controller: entry.sizeController,
                  readOnly: true,
                  suffixIcon: PopUpMenu(
                    items: con.size,
                    selectedItem: [entry.sizeController.text],
                    onTap: (i) {
                      entry.sizeController.text = con.size[i];
                      con.update();
                    },
                  ),
                ),
              ),
              12.width,
              Expanded(
                child: CommonTextField(
                  labelText: 'Qty',
                  fillColor: AppColors.background,
                  controller: entry.qtyController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}