import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  static const String route = '/terms';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Terms and Conditions'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '1. Introduction',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'By accessing or using our app, you agree to be bound by these terms and conditions. If you do not agree to these terms and conditions, you may not access or use the app.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '2. Use of the App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You may use the app only for lawful purposes and in accordance with these terms and conditions. You agree not to use the app:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        '• In any way that violates any applicable federal, state, local, or international law or regulation.'),
                    SizedBox(height: 5),
                    Text(
                        '• For the purpose of exploiting, harming, or attempting to exploit or harm minors in any way by exposing them to inappropriate content, asking for personally identifiable information, or otherwise.'),
                    SizedBox(height: 5),
                    Text(
                        '• To transmit, or procure the sending of, any advertising or promotional material, including any "junk mail," "chain letter," "spam," or any other similar solicitation.'),
                    SizedBox(height: 5),
                    Text(
                        '• To impersonate or attempt to impersonate the app owner, another user, or any other person or entity.'),
                    SizedBox(height: 5),
                    Text(
                        '• To engage in any other conduct that restricts or inhibits anyone\'s use or enjoyment of the app, or which, as determined by us, may harm the app owner or users of the app or expose them to liability.'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '3. Intellectual Property Rights',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The app and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by the app owner, its licensors, or other providers of such material and are protected by United States and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '4. Disclaimer of Warranties',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The app owner cannot and does not guarantee or warrant that files available for downloading from the internet or the app will be free of viruses or other destructive code. You are responsible for implementing sufficient procedures and checkpoints to satisfy your particular requirements for anti-virus protection and accuracy of data input and output, and for maintaining a means external to our app for any reconstruction of any lost data.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '5. Limitation of Liability',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'In no event will the app owner, its affiliates, or their licensors, service providers, employees, agents, officers, or directors be liable for damages of any kind, under any legal theory, arising out of or in connection with your use, or inability to use, the app, any websites linked to it, any content on the app or such other websites, including any direct, indirect, special, incidental, consequential, or punitive damages, including but not limited to, personal injury, pain and suffering, emotional distress, loss of revenue, loss of profits, loss of business or anticipated savings, loss of use, loss of goodwill, loss of data, and whether caused by tort (including negligence), breach of contract, or otherwise, even if foreseeable.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
