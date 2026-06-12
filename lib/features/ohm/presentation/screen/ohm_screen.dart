import 'package:flutter/material.dart';
import 'package:sparky/component/button/common_button.dart';
import 'package:sparky/component/text/common_text.dart';
import 'package:sparky/component/text_field/common_text_field.dart';
import 'package:sparky/utils/extensions/extension.dart';

class OhmScreen extends StatefulWidget {
  const OhmScreen({super.key});

  @override
  State<OhmScreen> createState() => _OhmScreenState();
}

class _OhmScreenState extends State<OhmScreen> {
  final _powerCtrl = TextEditingController();
  final _voltageCtrl = TextEditingController();
  final _currentCtrl = TextEditingController();
  String _result = '';


  // void _calculate() {
  //   final p = double.tryParse(_powerCtrl.text.trim());
  //   final v = double.tryParse(_voltageCtrl.text.trim());
  //   final i = double.tryParse(_currentCtrl.text.trim());
  //
  //   setState(() {
  //     if (v != null && i != null && p == null) {
  //       final result = v * i;
  //       _powerCtrl.text = result.toStringAsFixed(2);
  //       _result = 'Power = ${result.toStringAsFixed(2)} W';
  //     } else if (p != null && i != null && v == null) {
  //       final result = p / i;
  //       _voltageCtrl.text = result.toStringAsFixed(2);
  //       _result = 'Voltage = ${result.toStringAsFixed(2)} V';
  //     } else if (p != null && v != null && i == null) {
  //       final result = p / v;
  //       _currentCtrl.text = result.toStringAsFixed(2);
  //       _result = 'Current = ${result.toStringAsFixed(2)} A';
  //
  //       // ✅ ৩টাই দিলে Resistance বের হবে
  //     } else if (p != null && v != null && i != null) {
  //       final resistance = (v * v) / p;
  //       _result = 'Resistance = ${resistance.toStringAsFixed(2)} Ω';
  //
  //     } else {
  //       _result = '⚠️ Please fill at least 2 fields';
  //     }
  //   });
  // }

  void _calculate() {
    final p = double.tryParse(_powerCtrl.text.trim());
    final v = double.tryParse(_voltageCtrl.text.trim());
    final i = double.tryParse(_currentCtrl.text.trim());

    setState(() {
      if (v != null && i != null && p == null) {
        final result = v * i;
        _powerCtrl.text = result.toStringAsFixed(2);
        _result = 'Power = ${result.toStringAsFixed(2)} W';
      } else if (p != null && i != null && v == null && i != 0.0) {
        final result = p / i;
        _voltageCtrl.text = result.toStringAsFixed(2);
        _result = 'Voltage = ${result.toStringAsFixed(2)} V';
      } else if (p != null && v != null && i == null && v != 0.0) {
        final result = p / v;
        _currentCtrl.text = result.toStringAsFixed(2);
        _result = 'Current = ${result.toStringAsFixed(2)} A';
      } else {
        _result = 'Please leave exactly ONE field empty';
      }
    });
  }

  void _clear() {
    setState(() {
      _powerCtrl.clear();
      _voltageCtrl.clear();
      _currentCtrl.clear();
      _result = '';
    });
  }

  @override
  void dispose() {
    _powerCtrl.dispose();
    _voltageCtrl.dispose();
    _currentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Ohm Law',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CommonTextField(
              hintText: 'Power (Watts)',
              controller: _powerCtrl,
              keyboardType: TextInputType.number,
            ),
            20.height,
            CommonTextField(
              hintText: 'Voltage (Volts)',
              controller: _voltageCtrl,
              keyboardType: TextInputType.number,
            ),
            20.height,
            CommonTextField(
              hintText: 'Current (Amps)',
              controller: _currentCtrl,
              keyboardType: TextInputType.number,
            ),
            24.height,

            if (_result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withOpacity(0.15),
                      Colors.teal.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.bolt, color: Colors.teal, size: 32),
                    const SizedBox(height: 8),
                    const Text(
                      'Result',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.teal,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    titleText: 'Calculate',
                    buttonRadius: 30,
                    onTap: _calculate,
                  ),
                ),
                12.width,
                Expanded(
                  child: CommonButton(
                    titleText: 'Clear',
                    buttonRadius: 30,
                    onTap: _clear,
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