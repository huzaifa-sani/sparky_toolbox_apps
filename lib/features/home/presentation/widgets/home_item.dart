import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/text/common_text.dart';
import '../../../../utils/constants/app_colors.dart';

class HomeItem extends StatelessWidget {
  const HomeItem({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.onSurface.withOpacity(0.7),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Get.toNamed(item['route']);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(item['icon'], size: 48, color: AppColors.white),

              CommonText(text: item['name'], fontSize: 20, maxLines: 2, top: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// return Container(
// margin: const .all(10),
// height: 100,
// width: 100,
// decoration: BoxDecoration(
// color: const Color(0xffE0E7ED),
// borderRadius: BorderRadius.circular(10),
// ),
//
// child: Column(
// mainAxisAlignment: .center,
// children: [
// const Icon(Icons.home),
// CommonText(text: item['name'], color: Colors.black26),
// ],
// ),
// );
