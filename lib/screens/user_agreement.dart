import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/topbar.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: TopBar(),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // CircleAvatar(
              //     radius: 70, backgroundImage: AssetImage('images/arslan.jpg')),
              SizedBox(
                height: 50,
              ),
              Text(
                'User License Agreement',
                style: TextStyle(
                    fontFamily: 'Pacifico',
                    color: Color.fromARGB(255, 19, 38, 94),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              // Text(
              //   '',
              //   style: TextStyle(
              //       fontFamily: 'SourceSansPro',
              //       letterSpacing: 2.5,
              //       color: Color(0xfff07b3f),
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold),
              // ),
              SizedBox(
                height: 20,
                width: 350,
                child: Divider(
                  color: Color.fromARGB(255, 19, 38, 94),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                  // leading: Icon(
                  //   Icons.phone,
                  //   color: Color(0xfff07b3f),
                  // ),
                  title: Text(
                    'This End User License Agreement ("EULA") is a legal agreement between you and eAgree Inc. ("us", "we", or "our") and governs your use of the eAgree App (the "Application"). By using the Application, you accept this EULA and agree to be bound by its terms and conditions. If you do not agree to the terms of this EULA, do not use the Application.\n\n1.	License\n\n Subject to the terms and conditions of this EULA, we grant you a limited, non-exclusive, non-transferable, revocable license to use the Application solely for your personal, non-commercial use. You may not sublicense, distribute, modify, or create derivative works based on the Application. You may not reverse engineer, decompile, or disassemble the Application.\n\n2.	Ownership\n\nThe Application and all intellectual property rights therein, including but not limited to copyrights, trademarks, and trade secrets, are owned by us or our licensors. This EULA does not grant you any ownership rights in the Application or any of its content.\n\n3.	Termination\n\nWe reserve the right to terminate this EULA and your access to the Application at any time, for any reason, and without notice. Upon termination, your right to use the Application will immediately cease.\n\n4.	Disclaimer of Warranties\n\nThe Application is provided on an "as is" and "as available" basis. We make no warranties, express or implied, including but not limited to the implied warranties of merchantability, fitness for a particular purpose, and non-infringement. We do not warrant that the Application will be error-free or that it will meet your requirements.\n\n5.	Limitation of Liability\n\nIn no event shall we be liable for any damages, including but not limited to direct, indirect, special, incidental, or consequential damages, arising out of or in connection with the use or inability to use the Application.\n\n6.	Governing Law\n\nThis EULA and your use of the Application shall be governed by and construed in accordance with the laws of Canada.\n\n7.	Entire Agreement\n\nThis EULA constitutes the entire agreement between you and us and supersedes all prior or contemporaneous communications and proposals, whether oral or written. If any provision of this EULA is found to be invalid or unenforceable, that provision shall be enforced to the maximum extent possible, and the remaining provisions shall remain in full force and effect.\n\n8.	Changes to this EULA\n\nWe reserve the right to modify this EULA at any time. Any changes to this EULA will be effective immediately upon posting on the Application. Your continued use of the Application after any changes have been made will constitute your acceptance of such changes.',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              // Card(
              //   margin: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
              //   child: ListTile(
              //     leading: Icon(
              //       Icons.email,
              //       color: Color(0xfff07b3f),
              //     ),
              //     title: Text(
              //       'ch.arslan.95@gmail.com',
              //       style: TextStyle(
              //         fontFamily: 'SourceSansPro',
              //         color: Color(0xfff07b3f),
              //         fontSize: 20,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
