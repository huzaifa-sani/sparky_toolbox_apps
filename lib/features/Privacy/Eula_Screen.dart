import 'package:flutter/material.dart';
import 'package:sparky/component/text/common_text.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'EULA',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'END USER LICENSE AGREEMENT (EULA)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Last Updated: 2/19/2026',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This End User License Agreement ("Agreement") is a legally binding agreement between you ("User," "you," or "your") and TrinFJH Tech Solutions ("Company," "we," "us," or "our") governing your use of the Sparky Toolbox mobile application (the "App").\n\n'
                  'By purchasing, downloading, installing, accessing, or using the App through the Apple App Store or Google Play Store, you acknowledge that you have read, understood, and agree to be bound by this Agreement.\n\n'
                  'You further represent and warrant that you are at least 18 years of age and legally capable of entering into a binding agreement.\n\n'
                  'If you do not agree to this Agreement, do not download, install, access, or use the App.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 1
            Text(
              '1. License Grant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'TrinFJH Tech Solutions grants you a limited, non-exclusive, non-transferable, revocable license to use Sparky Toolbox for personal or commercial purposes within the United States, subject to this Agreement. You may not:\n\n'
                  '• Copy, reproduce, distribute, or resell the App.\n'
                  '• Reverse engineer, decompile, disassemble, or attempt to extract source code.\n'
                  '• Extract embedded calculation logic or data.\n'
                  '• Use the App to develop a competing product.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 2
            Text(
              '2. Independent Tool – No Affiliation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sparky Toolbox is an independent calculation tool. It is not affiliated with, endorsed by, sponsored by, or published by any code authority, standards organization, or governmental agency. The App does not represent itself as an official publication of any specific code book. The App does not constitute an official publication of any nationally recognized safety standard.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 3
            Text(
              '3. No Professional, Engineering, or Legal Advice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The App provides automated calculation assistance only. It does not replace licensed professional judgment, engineering review, or account for local amendments or Authority Having Jurisdiction (AHJ) interpretations. Requirements vary by jurisdiction. You are solely responsible for verifying all calculations and confirming compliance with applicable laws and local regulations.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 4
            Text(
              '4. User Responsibility & Assumption of Risk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Technical work involves inherent risks, including but not limited to property damage, equipment failure, serious bodily injury, fire, or death. The App is intended for use by individuals with appropriate technical knowledge and experience. By using the App, you acknowledge and agree that:\n\n'
                  '• You are responsible for independently verifying all outputs before implementation.\n'
                  '• You will confirm sizing, protection, and installation conditions independently.\n'
                  '• You assume all risks associated with reliance on App-generated calculations.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 5
            Text(
              '5. Disclaimer of Warranties',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE," WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. The Company makes no guarantee that the App\'s logic aligns with the specific version of any technical standards or local code books currently adopted in your jurisdiction.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 6
            Text(
              '6. Limitation of Liability',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'To the maximum extent permitted by law, TrinFJH Tech Solutions shall not be liable for any direct, indirect, incidental, or consequential damages, including financial loss, project delays, property damage, personal injury, or death. In no event shall the Company\'s total liability exceed the amount paid for the App.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 7
            Text(
              '7. Indemnification',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You agree to indemnify, defend, and hold harmless TrinFJH Tech Solutions from and against any third-party claims, damages, or expenses (including legal fees) arising out of your use of the App or any physical work performed based on its outputs.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 8
            Text(
              '8. Platform Acknowledgment (Apple & Google)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This Agreement is between you and TrinFJH Tech Solutions only. Apple Inc. and Google LLC are not responsible for the App, its content, or maintenance. You acknowledge they are third-party beneficiaries and may enforce this Agreement as applicable.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 9
            Text(
              '9. Dispute Resolution & Binding Arbitration',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Any dispute, claim, or controversy arising out of or relating to this Agreement or the use of the App shall be settled by binding arbitration rather than in court. You agree that such arbitration shall be conducted on an individual basis and not in a class or representative action. You expressly waive any right to participate in a class action lawsuit or class-wide arbitration. You waive your right to a trial by jury.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 10
            Text(
              '10. Governing Law & Severability',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This Agreement is governed by the laws of the United States and the state in which TrinFJH Tech Solutions is registered. If any provision is found unenforceable, the remaining provisions shall remain in full force.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            Text(
              '11. Contact Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'TrinFJHTechSolutions LLC\n'
                  '[1309 Coffeen Ave STE 1200]\n'
                  '[Sheridan, Wyoming, 82801]\n'
                  "Email: Contact@trinfjhtechsolutions.com",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 30),

          ],
        ),
      ),
    );
  }
}