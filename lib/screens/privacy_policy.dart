import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacypolicyScreen extends StatefulWidget {
  @override
  State<PrivacypolicyScreen> createState() => _PrivacypolicyScreenState();
}

class _PrivacypolicyScreenState extends State<PrivacypolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Privacy And Policy',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          //backgroundColor: const Color(0xFF44140F),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )), // Set the body background color
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text("Storem Privacy Statement",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                    //  color: Color(0xFF44140F),
                      fontSize: 28)),
              SizedBox(
                height: 18,
              ),
              Text("Last Updated: Sep 10, 2024",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //color: Colors.black,
                      fontSize: 20)),
              SizedBox(
                height: 8,
              ),
              Text(
                "Welcome to Storem! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our mobile application designed to create stories and activities for self-help regarding any social circumstances or imaginative scenarios. By using our Storem app, you agree to the collection and use of information in accordance with this policy",
                style: TextStyle(
                 // color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Our Collection, Use, and Disclosure of Personal Information",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //color: Colors.black,
                    fontSize: 20),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "We collect the following categories of personal information about you:",
                style: TextStyle(
                  //color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Personal details:',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      //  color: Colors.black
                    ),
                  ),
                  TextSpan(
                    text:
                        ' When you create your Storem account, we collect your contact information (such as your email address). We may collect some of the information you provide us directly when you contact us for support or feedback.',
                    //style: TextStyle(color: Colors.black),
                  )
                ],
              )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Storem account/profile information:',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black
                    ),
                  ),
                  TextSpan(
                    text:
                        'We collect information that is associated with your Storem account (such as profile name).',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Usage Data::',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        //color: Colors.black
                    ),
                  ),
                  TextSpan(
                    text:
                        'We may collect information about how you access and use StoreM (such as app text input and similar functionality).',
                  //  style: TextStyle(color: Colors.black),
                  )
                ],
              )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: ' Communications:',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black
                    ),
                  ),
                  TextSpan(
                    text:
                        'If you communicate with StoreM by engaging in our surveys or feedback requests, we collect the contents of such communications. We also collect details of communications that we send you (such as via email, push notifications, text message, or within the Dosth AI platform), and information about your interaction and engagement with these communications.',
                    //style: TextStyle(color: Colors.black),
                  )
                ],
              )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Cookies and Tracking Technologies:',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black
                    ),
                  ),
                  TextSpan(
                    text:
                        'We may use cookies and similar tracking technologies to track the activity on our Platform and hold certain information. You can instruct your device to refuse all cookies or to indicate when a cookie is being sent. However, some features of the Platform may not function properly without cookies.',
                    //style: TextStyle(color: Colors.black),
                  )
                ],
              )),
              SizedBox(
                height: 15,
              ),
              Text(
                "Where We Collect Personal Information From.",
                style: TextStyle(
                 // color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "We collect your personal information from the following sources:",
                style: TextStyle(
                 // color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Directly from you:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                           // color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        ' When you register with StoreM, update your StoreM account or profile, correspond with us, or respond to our surveys, you may provide (and we will collect) the following categories of personal information: profile display name, and communications.',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Text(
                "How We Use Your Personal Information.",
                style: TextStyle(
                   // color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "We use your personal information to provide, maintain, improve, and promote the StoreM, and to communicate with you. This involves using the categories of personal information listed above for the following purposes:",
                style: TextStyle(
                 // color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'To provide, maintain, and improve the Platform',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                           // color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'including all features and functionalities, websites and app, user interfaces, and content and software associated with the StoreM. We use the following categories of personal information for this purpose: personal details, Dosth AI account/profile information, usage information, and communications.',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'To research, analyze, and improve our platform',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'such as monitoring, analyzing and understanding our audience by their usage data and to improve our platform content and optimize StoreM content selection and content display. This may also include processing your personal information in connection with any surveys you participate in.',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'To comply with law and enforce our Terms of Use',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                           // color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'including to satisfy applicable law, regulation, legal process, or governmental request, and to protect against harm to the rights, property or safety of Dosth AI, its users or the public, as required or permitted by law. We use the following categories of personal information for this purpose: personal details, Dosth AI account/profile information, usage information and communications.',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Text(
                "Who We Disclose Personal Information To.",
                style: TextStyle(
                    //color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "We do not share your personal information with third parties except in the following circumstances:",
                style: TextStyle(
                //  color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'With Your Consent:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'We may share your information with your consent or at your direction.',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Service Providers:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                           // color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'We may share your information with third-party service providers who perform services on our behalf, such as hosting, data analysis, payment processing, and customer support.',
                       // style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Safety, security and fraud prevention:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        ' Dosth AI and its Service Providers may disclose your personal information to third parties where we reasonably believe disclosure is needed for the purpose of: safety, security, and fraud prevention.',
                       // style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Compliance with law and enforcing our Terms of Use:',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or government agency).',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Business Transfers: ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            //color: Colors.black
                        ),
                      ),
                      TextSpan(
                        text:
                        'If we are involved in a merger, acquisition, or asset sale, your information may be transferred as part of that transaction.',
                        //style: TextStyle(color: Colors.black),
                      )
                    ],
                  )),


              SizedBox(
                height: 15,
              ),
              Text(
                "Your Data Protection Rights",
                style: TextStyle(
                    //color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Depending on your location, you may have the following data protection rights:",
                style: TextStyle(
                  //color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Access: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'You can request a copy of the personal information we hold about you.\n\n',
                      //style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Correction: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        //color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'You can request that we correct any inaccurate or incomplete information.\n\n',
                      //style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Deletion: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      //  color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'You can request that we delete your personal information, subject to certain exceptions.\n\n',
                     // style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Objection: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'You can object to the processing of your personal information in certain circumstances.\n\n',
                      //style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Restriction: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'You can request that we restrict the processing of your personal information in certain circumstances.\n\n',
                     // style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Data Portability: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        //color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'You can request a copy of your personal information in a structured, commonly used, and machine-readable format.',
                     // style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Children's Privacy",
                style: TextStyle(
                    //color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "We are committed to protecting the privacy of children. Our Patform is intended for use by individuals of all ages, but users under the age of 18 require the involvement of a parent or guardian. If we learn that we have collected personal information from a child under 18 without parental consent, we will delete that information as quickly as possible. If you believe we might have any information from or about a child under 18, please contact us at contact@dosth.ai.",
                style: TextStyle(
                  //color: Colors.black,
                  //fontSize: 20
                ),
              ), SizedBox(
                height: 15,
              ),
              Text(
                "Changes to This Privacy Policy",
                style: TextStyle(
                   // color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the ""Last Updated" "date at the top. Your continued use of the Platform after any changes indicates your acceptance of the updated Privacy Policy.",
                style: TextStyle(
                 // color: Colors.black,
                  //fontSize: 20
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Contact Us",
                style: TextStyle(
                   // color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "If you have any questions or concerns about this Privacy Policy, please contact us at contact@dosth.ai.",
                style: TextStyle(
                //  color: Colors.black,
                  //fontSize: 20
                ),
              ),

            ],
          ),
        ));
  }
}
