import 'package:flutter/material.dart';
import 'package:graduation_project/modules/instructor_login/insrtuctor_login_screen.dart';
import 'package:graduation_project/modules/student_login/student_login_screen.dart';
import 'package:graduation_project/shared/components/components.dart';

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_rounded,
                size: 200,
              ),
              Text(
                "HU-QR",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                height: 40,
                width: double.infinity,
                child: defaultButton(
                    function: () {
                      navigateTo(context: context, widget: InstructorLogin());
                    },
                    text: 'Instructor'),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                height: 40,
                width: double.infinity,
                child: defaultButton(
                    function: () {
                      navigateTo(context: context, widget: StudentLogin());
                    },
                    text: 'STUDENT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
