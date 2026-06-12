import 'package:flutter/material.dart';
import 'package:sparky/component/text/common_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(
          text: 'Privacy Policy',
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
              'PRIVACY POLICY',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Last Updated: 2/21/2026',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white60,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This Privacy Policy describes how TrinFJH Tech Solutions ("Company," "we," "us," or "our") handles information in connection with the Sparky Toolbox mobile application (the "App").',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 1
            Text(
              '1. Information We Collect',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sparky Toolbox does not collect, store, transmit, or share any personal information.\n\n'
                  'Specifically:\n'
                  '• We do not require user accounts.\n'
                  '• We do not collect names, email addresses, phone numbers, or contact information.\n'
                  '• We do not collect location data.\n'
                  '• We do not collect device identifiers.\n'
                  '• We do not collect usage analytics.\n'
                  '• We do not collect financial information (payments are processed solely through the Apple App Store or Google Play Store).\n\n'
                  'All calculations performed within the App occur locally on your device.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 2
            Text(
              '2. Data Storage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The App does not store personal data on our servers.\n\n'
                  'Any preferences or saved values (if applicable) are stored locally on your device and are not transmitted to us.\n\n'
                  'We do not have access to any information entered into the App.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 3
            Text(
              '3. Third-Party Services',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The App does not use third-party analytics, advertising networks, tracking tools, or external data services.\n\n'
                  'However, distribution platforms such as:\n'
                  '• Apple App Store\n'
                  '• Google Play Store\n\n'
                  'may collect information in accordance with their own privacy policies. We do not control and are not responsible for data collection performed by those platforms.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 4
            Text(
              '4. Age Restrictions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This App is intended for use by individuals who are at least 18 years of age.\n\n'
                  'By using the App, you represent and warrant that you are 18 years of age or older.\n\n'
                  'The App does not collect, store, or process personal information from any users, regardless of age.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 5
            Text(
              '5. Data Security',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Because we do not collect or store user data, there is no personal data maintained on our servers.\n\n'
                  'All calculations are performed locally on the user\'s device.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 6
            Text(
              '6. Your Privacy Rights',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Since we do not collect personal data, there is no personal information to access, modify, delete, or request.\n\n'
                  'If you have questions regarding this Privacy Policy, you may contact us using the information below.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 7
            Text(
              '7. Changes to This Privacy Policy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may update this Privacy Policy from time to time. Any updates will be reflected by revising the "Last Updated" date above.\n\n'
                  'Continued use of the App after changes constitutes acceptance of the revised policy.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
                height: 1.7,
              ),
            ),

            SizedBox(height: 20),

            // Section 8
            Text(
              '8. Contact Information',
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