import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storem/screens/profile.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Terms And Conditions', style: TextStyle(color: Colors.red,fontSize: 28, fontWeight: FontWeight.bold),),
      // backgroundColor:
      // const Color(0xFF44140F),
      centerTitle: true,
      leading: IconButton(onPressed: () {
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back,color: Colors.red,)),// Set the body background color
    ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 14, color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: 'Last Updated: Sep 10, 2024\n\n',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Welcome to Storem! These Terms of Use ("Terms") govern your use of our mobile application ("app") designed to store your favorite links at one place. By downloading, installing, or using our Storem, you agree to these Terms.\n\n',
              ),
              _sectionTitle('1. Acceptance of Terms'),
              _sectionBody('By accessing and using the Storeem app, you accept and agree to be bound by these Terms, our Privacy Policy, and any additional terms and conditions that may apply. If you are using the app on behalf of a minor or another person, you represent that you have the authority to accept these Terms on their behalf.\n\n'),
              _sectionTitle('2. Eligibility'),
              _sectionBody('You must be at least 18 years of age to use Storem. Individuals under the age of 18 may use the app  with the involvement of a parent or legal guardian, under such persons account and otherwise subject to these Terms of Use".\n\n'),
              _sectionTitle('3. License to Use'),
              _sectionBody('We grant you a limited, non-exclusive, non-transferable  revocable license to use this app for personal, non-commercial purposes in accordance with these Terms.\n\n'),
              _sectionTitle('4. User Accounts'),
              _sectionBody('To access certain features of this app, you may need to create an account. You agree to provide accurate, current, and complete information and to update your information as necessary. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\n'),
              _sectionTitle('5. Content and Intellectual Property'),
              _sectionBody('All content available on storem app, including all the stored links  is the property of Storem app or its licensors and is protected by intellectual property laws.The quality of the display of the Storem app content may vary from device to device, and may be affected by a variety of factors, such as your location, the bandwidth available through and/or speed of your Internet connection; however, we recommend a faster connection for improved quality. Storem makes no representations or warranties about the quality of your experience on your display.\n\n'),
              _sectionTitle('6. User-Generated Content'),
              _sectionBody('You may have the ability to store your favorite links through this app. You retain ownership of any content you create, but you grant us a worldwide, royalty-free, sublicensable, and transferable license to use, reproduce, distribute, modify, and display your content in connection with the app. You are responsible for the content you create and must ensure it does not violate any laws or infringe on third-party rights.\n\n'),
              _sectionTitle('7. Prohibited Uses'),
              _sectionBody('You agree not to misuse the app, including circumventing security features, reverse-engineering software, or uploading harmful material.\n\n'),
              _sectionTitle('8. Passwords and Account Access'),
              _sectionBody('You are responsible for any activity that occurs through the Storem account. By allowing others to access the account (which includes access to information on viewing activity for the account), you agree that such individuals are acting on your behalf and that you are bound by any changes that they may make to the account, including but not limited to changes to your profile. To help maintain control over the account and prevent any unauthorized users from accessing the account, you should maintain control over the devices that are used to access the app and not reveal the password or details associated with the account to anyone. You agree to provide and maintain accurate information relating to your account, including a valid email address so we can send you account related notices. We can terminate your account or place your account on hold in order to protect you from identity theft or other fraudulent activity. Storem is not obligated if the device is lost or stolen, sold or the misuse of your account by any means.\n\n'),
              _sectionTitle('9. Privacy'),
              _sectionBody('Your use of the Storem app is subject to our Privacy Policy, which explains how we collect, use, and protect your personal information. By using the app, you consent to the collection and use of your information as described in the Privacy Policy.\n\n'),
              _sectionTitle('10. Termination'),
              _sectionBody('We may terminate or suspend your access to Storem app at any time, with or without cause or notice, for conduct that we believe violates these Terms or is harmful to other users or us.\n\n'),
              _sectionTitle('11. Disclaimers and Liability Limitations'),
              _sectionBody('11.1. The storem app and software associated therewith, or any other features or functionalities associated with the storem app, are provided "as is" and "as available" with all faults and without warranty of any kind. storem make no warranties, express or implied, regarding the app, including but not limited to its accuracy, reliability, or availability. we disclaim all warranties to the fullest extent permitted by law.\n\n '
                  '11.2  To the extent permitted by law, we shall not be liable for any direct, indirect, special, consequential, or punitive damages arising out of or related to your use of the app, even if we have been advised of the possibility of such damages.."\n\n'),
              _sectionTitle('12. Miscellaneous'),
              _sectionBody('These Terms are governed by Texas law. We may update them occasionally, and continued use signifies acceptance.\n\n'),
             _sectionTitle('12.1. Indemnification'),
              _sectionBody('You agree to indemnify, defend, and hold harmless Storem and its affiliates, officers, directors, employees, and agents from any claims, liabilities, damages, losses, and expenses, including legal fees, arising out of or related to your use of the app or violation of these Terms.\n\n'),
             _sectionTitle('12.2. Governing Law'),
              _sectionBody('These Terms shall be governed by and construed in accordance with the laws of the State of Texas, U.S.A. without regard to its conflict of laws provisions.These terms will not limit any consumer protection rights that you may be entitled to under the mandatory laws of your state of residence.\n\n'),
             _sectionTitle('12.3. Changes to Terms of Use'),
              _sectionBody('Storem may reserve the right to change these Terms of Use from time to time. We will notify you of any changes by updating the "Last Updated" date at the top of these Terms. Your continued use of the app after any changes indicates your acceptance of the new Terms.\n\n'),
              _sectionTitle('12.4. Feedback'),
              _sectionBody('Storem app is free to use any comments, information, ideas, concepts, reviews, or techniques or any other material contained in any communication you may send to us ("Feedback"), including responses to questionnaires or through postings to the Storem app, including our websites and user interfaces, worldwide and in perpetuity without further compensation, acknowledgement or payment to you for any purpose whatsoever including, but not limited to, developing, manufacturing and marketing products and creating, modifying or improving Storem app. In addition, you agree not to enforce any "moral rights" in and to the Feedback, to the extent permitted by applicable law.\n\n'),
              _sectionTitle('12.5. Survival'),
              _sectionBody('If any provision or provisions of these Terms of Use shall be held to be invalid, illegal, or unenforceable, the validity, legality and enforceability of the remaining provisions shall remain in full force and effect.\n\n'),
              _sectionTitle('12.6 Contact Us'),
              _sectionBody('If you have any questions or concerns about these Terms, please contact us at contact@storem'),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _sectionTitle(String title) {
    return TextSpan(
      text: title + '\n',
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  TextSpan _sectionBody(String body) {
    return TextSpan(
      text: body,
      style: TextStyle(fontSize: 14, color: Colors.white),
    );
  }
}