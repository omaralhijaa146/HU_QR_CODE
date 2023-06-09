import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/shared/services_and_permissions/services_and_permissions.dart';

import 'instructor_cubit/instructor_layout_cubit.dart';
import 'instructor_cubit/instructor_layout_states.dart';

class InstructorLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InstructorLayoutCubit()..contextLayout = context,
      child: BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
        builder: (context, state) {
          checkUserPermission(context);
          var cubit = InstructorLayoutCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Icon(
                Icons.qr_code_rounded,
                size: 30,
              )),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavBar,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBarState(index);
              },
            ),
            body: InstructorLayoutCubit.get(context)
                .LayoutScreens[InstructorLayoutCubit.get(context).currentIndex],
          );
        },
        listener: (context, state) {
          //Duration(seconds: )
        },
      ),
    );
  }
}
