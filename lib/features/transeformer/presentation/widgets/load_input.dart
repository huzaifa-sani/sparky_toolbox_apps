import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import '../controller/transerformer_controller.dart';

class LoadRowItem extends StatelessWidget {
  final TransformerController controller;
  final int index;

  const LoadRowItem({
    super.key,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final row = controller.loadRows[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // ── Amps + Qty + Delete ───────────────────────────
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
                  onTap: () => controller.removeLoadRow(index),
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

          // ── Continuous Load checkbox ───────────────────────
          GestureDetector(
            onTap: () => controller.toggleContinuous(index),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: row.isContinuous
                          ? const Color(0xFFC0556E)
                          : Colors.white54,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: row.isContinuous
                        ? const Color(0xFFC0556E)
                        : Colors.transparent,
                  ),
                  child: row.isContinuous
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                8.width,
                const Text(
                  'Continuous Load (Calculated @ 125%)',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension SpacingExt on num {
  Widget get height => SizedBox(height: toDouble());
  Widget get width => SizedBox(width: toDouble());
}