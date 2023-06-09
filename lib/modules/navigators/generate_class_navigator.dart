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
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage(
                  "assets/icons/icons_qr_code.png",
                ),
                width: 100,
                height: 100,
              ),
              Text(
                "HU-QR",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 80,),
              Container(
                height: 40,
                width: double.infinity,
                child: MaterialButton(
                  onPressed: (){
                    navigateTo(context: context, widget: InstructorLogin());
                  },
                  child: Text("Instructor"),
                  color: Colors.cyan,
                ),
              ),
              SizedBox(height: 15.0,),
              Container(
                height: 40,
                width: double.infinity,
                child: MaterialButton(
                  onPressed: (){
                    navigateTo(context: context, widget: StudentLogin());
                  },
                  child: Text("Student"),
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
