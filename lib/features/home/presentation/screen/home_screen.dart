import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/features/Privacy/Privacy_PolicyScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/route/app_routes.dart';
import '../../../Privacy/Disclaimer_Screen.dart';
import '../../../Privacy/Eula_Screen.dart';
import '../controller/home_controller.dart';
import '../widgets/home_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) => const _ExitDialog(),
    );
    if (shouldExit == true) {
      SystemNavigator.pop();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(
            text: 'Sparky Toolbox',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: GetBuilder<HomeController>(
          builder: (controller) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  // ── Calculator Grid ──────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final item = controller.homeItems[index];
                          return HomeItem(item: item);
                        },
                        childCount: controller.homeItems.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        children: [
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 8),
                          _legalButton(
                            icon: Icons.info_outline_rounded,
                            label: 'Disclaimer',
                            onTap: (){

                              Get.to(() => const DisclaimerScreen());

                            }
                          ),
                          _legalButton(
                            icon: Icons.privacy_tip_outlined,
                            label: 'Privacy Policy',
                            onTap: () async {
                              final Uri url = Uri.parse('https://trinfjhtechsolutions.com/privacy');

                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                // Debug করার জন্য
                                debugPrint('Could not launch $url');
                                Get.snackbar('Message', 'Could not open link');
                              }
                            },
                          ),
                          _legalButton(
                            icon: Icons.description_outlined,
                            label: 'End User License Agreement (EULA)',
                            onTap:(){

                              Get.to(() => const EulaScreen());

                            }
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Sparky Toolbox. All rights reserved.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
                border: Border.all(
                  color: Colors.redAccent.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.power_settings_new_rounded,
                color: Colors.redAccent,
                size: 36,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Exit App?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Are you sure you want to\nexit Sparky Toolbox?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.45),
                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white.withOpacity(0.06),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF5350), Color(0xFFB71C1C)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Widget _legalButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white38),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white38,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white24),
        ],
      ),
    ),
  );
}