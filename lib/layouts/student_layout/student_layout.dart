import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_cubit.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_states.dart';
import 'package:graduation_project/shared/services_and_permissions/services_and_permissions.dart';

class StudentLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentLayoutCubit()..contextLayout = context,
      lazy: false,
      child: BlocConsumer<StudentLayoutCubit, StudentLayoutStates>(
        builder: (context, state) {
          checkUserPermission(context);
          return Scaffold(
            appBar: AppBar(
              title: Icon(
                Icons.qr_code_rounded,
                size: 30,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: StudentLayoutCubit.get(context).bottomNavBar,
              currentIndex: StudentLayoutCubit.get(context).currentIndex,
              onTap: (index) {
                StudentLayoutCubit.get(context).changeBottomNavBarState(index);
              },
            ),
            body: StudentLayoutCubit.get(context)
                .layoutScreens[StudentLayoutCubit.get(context).currentIndex],
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
