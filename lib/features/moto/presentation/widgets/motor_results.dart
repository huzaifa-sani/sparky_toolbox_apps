import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/motor_controller.dart';

class MotorResults extends StatelessWidget {
  const MotorResults({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MotorController>(
      builder: (controller) {
        if (!controller.hasResult) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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

              // Phase label
              Text(controller.phaseLabel,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00BFA5),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),

              // Motor FLC
              Text('Motor FLC: ${controller.fullLoadAmps} A',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),

              const Divider(height: 20, color: Color(0xFF1E3A3A)),

              // ── Overcurrent Protection (OCPD) ──────────────
              // Roadmap: "Overcurrent Protection (OCPD)"
              _sectionLabel('Overcurrent Protection (OCPD)'),
              const SizedBox(height: 8),
              _plainRow('Max Inverse-Time Breaker:', controller.maxITBreaker),
              const SizedBox(height: 4),
              _plainRow('Max Time-Delay Fuse:', controller.maxTDFuse),

              const Divider(height: 20, color: Color(0xFF1E3A3A)),

              _sectionLabel('Conductor Size'),
              const SizedBox(height: 8),
              _plainRow('Min. Ampacity (125%):', '${controller.minAmpacity} A'),
              const SizedBox(height: 4),
              _boldRow('Required Wire Size (75°C Cu):', controller.wireSize),

              const Divider(height: 20, color: Color(0xFF1E3A3A)),

              _sectionLabel('Equipment Grounding'),
              const SizedBox(height: 8),
              _boldRow('If using Breaker:', controller.egcBreaker),
              const SizedBox(height: 4),
              _boldRow('If using Fuse:', controller.egcFuse),

              const Divider(height: 20, color: Color(0xFF1E3A3A)),

              // const Text(
              //   'Note: Wire size is calculated strictly based on 125% of motor FLC per NEC 430.22.',
              //   style: TextStyle(
              //     fontSize: 11,
              //     color: Color(0xFF4DB6AC),
              //     fontStyle: FontStyle.italic,
              //     height: 1.4,
              //   ),
              // ),

            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF00BFA5),
          fontWeight: FontWeight.w500));

  Widget _plainRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF80CBC4)))),
      Text(value,
          style: const TextStyle(
              fontSize: 13, color: Color(0xFF80CBC4))),
    ]),
  );

  Widget _boldRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child: Text(label,
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
}