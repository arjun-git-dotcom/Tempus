import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We respect your privacy and are committed to protecting your personal information. This policy outlines how we collect, use, and safeguard your data.',
            ),
            SizedBox(height: 16),
            Text(
              'Information We Collect:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Usage Information: App usage statistics and preferences.',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Improve app performance and user experience.',
            ),
            Text(
              '- Personalize user interactions and features.',
            ),
            Text(
              '- Analyze user behavior to enhance app functionality.',
            ),
            SizedBox(height: 16),
            Text(
              'Data Sharing:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Data may be shared with third-party service providers for app functionality and analytics purposes.',
            ),
            SizedBox(height: 16),
            Text(
              'Your Choices:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Opt-out of data collection within the app settings.',
            ),
            SizedBox(height: 16),
            Text(
              'Security:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We employ measures to protect your information from unauthorized access or disclosure.',
            ),
            SizedBox(height: 16),
            Text(
              'Changes to This Policy:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may update this policy and will notify you of any changes.',
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have questions or concerns, please contact us.',
            ),
          ],
        ),
      ),
    );
  }
}

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text(
            'Terms of Use',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'These Terms of Use govern your use of our Timer App. By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.',
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('1. Use of the App'),
          _buildList([
            'The App is intended solely for timing purposes.',
            'You agree to use the App in accordance with these Terms and all applicable laws and regulations.',
          ]),
          _buildSectionTitle('2. Account Registration'),
          _buildList([
            'You may not need to register for an account to access the App.',
            'You agree to provide accurate and complete information when prompted.',
          ]),
          _buildSectionTitle('3. Intellectual Property'),
          _buildList([
            'The App and its content, including but not limited to text, graphics, logos, and images, are the property of [Your Company Name] and are protected by copyright and other intellectual property laws.',
            'You may not modify, reproduce, distribute, or create derivative works based on the App or its content without our prior written consent.',
          ]),
          _buildSectionTitle('4. User Content'),
          _buildList([
            'You may not be able to submit content to the App.',
          ]),
          _buildSectionTitle('5. Limitation of Liability'),
          _buildList([
            'To the fullest extent permitted by law, we disclaim all warranties, express or implied, regarding the App and its content.',
            'We will not be liable for any direct, indirect, incidental, consequential, or special damages arising out of or in any way related to your use of the App.',
          ]),
          _buildSectionTitle('6. Termination'),
          _buildList([
            'We reserve the right to terminate or suspend your access to the App at any time, with or without cause and without prior notice.',
            'Upon termination, your right to use the App will cease immediately.',
          ]),
          _buildSectionTitle('7. Changes to These Terms'),
          _buildList([
            'We may revise these Terms at any time by updating this page. By continuing to use the App after we post any changes, you accept the revised Terms.',
          ]),
          _buildSectionTitle('8. Governing Law'),
          _buildList([
            'These Terms are governed by the laws of [Your Jurisdiction], without regard to its conflict of law provisions.',
          ]),
          _buildSectionTitle('9. Contact Us'),
          _buildList([
            'If you have any questions or concerns about these Terms, please contact us at [Your Contact Information].',
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('• $item'),
              ))
          .toList(),
    );
  }
}

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Our Timer App'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Our Timer App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Our timer app is designed to provide a simple and efficient way to set and manage timers for various tasks and activities. With intuitive features and a user-friendly interface, it helps users stay organized and productive.',
            ),
            SizedBox(height: 16),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '- Create and customize multiple timers simultaneously.',
            ),
            Text(
              '- Set reminders and notifications for timers.',
            ),
            Text(
              '- Track elapsed time and remaining time for each timer.',
            ),
            Text(
              '- Save frequently used timers for quick access.',
            ),
            SizedBox(height: 16),
            Text(
              'Our mission is to provide users with a reliable and versatile timer app that enhances productivity and time management skills.',
            ),
            SizedBox(height: 16),
            Text(
              'For any inquiries or feedback, please contact us. Thank you for choosing our app!',
            ),
          ],
        ),
      ),
    );
  }
}
