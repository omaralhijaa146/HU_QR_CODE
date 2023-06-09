import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_cubit.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_states.dart';
import 'package:graduation_project/layouts/student_layout/student_layout.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/custom_stream_builder/custom_stream_builder.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';

class CheckStudentClassInfo extends StatelessWidget {
  StudentRegisterModel studentRegisterModel;
  ClassInfoModel model;
  String QrCode;
  dynamic layoutContext;
  bool isDone = false;

  CheckStudentClassInfo(
      this.studentRegisterModel, this.model, this.QrCode, this.layoutContext);

  @override
  Widget build(BuildContext context1) {
    return BlocProvider(
      create: (context) => StudentLayoutCubit()
        ..contextLayout = layoutContext
        ..studentRegisterModel = this.studentRegisterModel,
      lazy: false,
      child: BlocConsumer<StudentLayoutCubit, StudentLayoutStates>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    navigateAndReplace(
                        context: context, widget: StudentLayout());
                  },
                  icon: Icon(Icons.arrow_back))),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 20),
                  child: Text('checking class and location info :'),
                ),
                CustomStreamBuilder(
                  listener: (value) {
                    if (value[value.length - 1] == 'End') {
                      isDone = true;
                    }
                    print("VALUE ()()()()()()()()()()  ${value}");
                    /*if (value) {
                      navigateAndReplace(
                          context: context, widget: StudentLayout());
                    }*/
                  },
                  stream: StudentLayoutCubit.get(context)
                      .checkIfAttended1(QrCode, model),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("SNAPSHOT WAITING ***********************");
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      print(
                          "SNAPSHOT HAS DATA   ${snapshot.data?.elementAt(0).keys.elementAt(0)}");
                      return Expanded(
                        child: Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                String mapKey = snapshot.data
                                    ?.elementAt(index)
                                    .keys
                                    .elementAt(0) as String;
                                String value = snapshot.data
                                    ?.elementAt(index)[mapKey] as String;
                                return Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(mapKey),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (value == 'checked' ||
                                          value == 'signed')
                                        Icon(size: 25, IconBroken.Shield_Done),
                                      if (value == 'wrong' ||
                                          value == 'unsigned')
                                        Icon(size: 25, IconBroken.Shield_Fail),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 15,
                              ),
                              itemCount: snapshot.data?.length as int,
                            ),
                            Spacer(),
                            defaultButton(
                                function: () {
                                  navigateAndReplace(
                                      context: context,
                                      widget: StudentLayout());
                                },
                                text: 'back to classes screen'),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Text('error');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is CheckIfAttendedSuccessState) {}
        print(state);
        /*if (state is CheckIfAttendedErrorState) {
          showDialog(
            context: context1,
            builder: (context) {
              return Center(
                child: Container(
                  height: 350,
                  width: 250,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          'Wrong Info : ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Text(
                                  '${index + 1} - ${StudentLayoutCubit.get(context).wrongInfo[index]}',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium);
                            },
                            separatorBuilder: (context, index) => myDividor(),
                            itemCount: StudentLayoutCubit.get(context)
                                .wrongInfo
                                .length),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).then((value) {});
        }*/
      }),
    );
  }

/*Column(
  children: [
  Padding(
  padding: const EdgeInsets.all(15.0),
  child: Center(
  child: Column(
  children: [
  Text('check info'),
  SizedBox(
  height: 20,
  ),
  state is CheckIfAttendedLoadingState
  ? Container(
  height: 30,
  width: 30,
  child: CircularProgressIndicator(),
  )
      : state is CheckIfAttendedSuccessState
  ? CircleAvatar(
  child: Icon(
  Icons.check_circle,
  color: Colors.green,
  ),
  )
      : CircleAvatar(
  child: Icon(
  Icons.cancel_outlined,
  color: Colors.red,
  ),
  ),
  ],
  ),
  ),
  ),
  Spacer(),
  defaultButton(
  function: () {
  navigateAndReplace(
  context: context1, widget: StudentLayout());
  },
  text: 'Back to Classes Screen')
  ],
  ),
  */
}
