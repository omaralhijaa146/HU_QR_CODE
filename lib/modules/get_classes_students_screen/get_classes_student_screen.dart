import 'package:flutter/material.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_cubit.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/modules/check_student_class_loc_class_info/check_student_class_loc_class_info.dart';
import 'package:graduation_project/shared/change_notifier/change_notifier.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:graduation_project/shared/components/qr_overlay.dart';
import 'package:graduation_project/shared/services_and_permissions/services_and_permissions.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class GetClassesStudentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkUserPermission(context);
    //StudentLayoutCubit.get(context).getClasses();
    return Stack(
      children: [
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return StreamBuilder(
                  stream: StudentLayoutCubit.get(context).getClassesInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Student Classes'),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return buildClassesItem(
                                        snapshot.data!.elementAt(index),
                                        StudentLayoutCubit.get(context)
                                            .contextLayout,
                                        context);
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        width: 20,
                                      ),
                                  itemCount: snapshot.data!.length),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('error classes'));
                    } else {
                      return Center(child: Text('no classes'));
                    }
                  });
            } else if (snapshot.hasError) {
              return Text('Error Ins');
            } else {
              return Text('no data');
            }
          },
          future: StudentLayoutCubit.get(context).getInfo(),
        ),
      ],
    );
  }

  Widget buildClassesItem(
      ClassInfoModel model, contextMain, contextGetClassScreen) {
    List<String> classRoomInfo = model.classRoomUid?.split('-') as List<String>;
    return StreamBuilder(
        stream: StudentLayoutCubit.get(contextGetClassScreen)
            .getCourseName(model.courseId as String),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ChangeNotifierProvider<ChangeNotifierHUQR>(
              create: (context) => ChangeNotifierHUQR(),
              child: Consumer<ChangeNotifierHUQR>(
                builder: (context, value, child) {
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          MobileScannerController mobileScannerController =
                              MobileScannerController(
                            detectionSpeed: DetectionSpeed.normal,
                            detectionTimeoutMs: 750,
                          );
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.7),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.grey[100],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 600,
                                  child: Stack(
                                    children: [
                                      MobileScanner(
                                        onDetect: (barcode) {
                                          mobileScannerController.barcodes
                                              .listen((event) {
                                            print(
                                                'listener QRRRRR ${event.barcodes.last.rawValue as String}');
                                            navigateAndReplace(
                                                context: context,
                                                widget: CheckStudentClassInfo(
                                                    StudentLayoutCubit.get(
                                                                contextGetClassScreen)
                                                            .studentRegisterModel
                                                        as StudentRegisterModel,
                                                    model,
                                                    event.barcodes.last.rawValue
                                                        as String,
                                                    contextMain));
                                          });
                                        },
                                        controller: mobileScannerController,
                                        startDelay: true,
                                      ),
                                      QRScannerOverlay(
                                        overlayColour:
                                            Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(model.color as int),
                                ),
                                child: Center(
                                  child: Text(
                                      '${snapshot.data![0]}${snapshot.data![snapshot.data!.length - 1]}'),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${snapshot.data}'),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${model.classNumber}'),
                              Spacer(),
                              Icon(IconBroken.Arrow___Right_2),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 4, top: 4),
                          child: Align(
                              alignment: AlignmentDirectional.bottomStart,
                              child:
                                  context.read<ChangeNotifierHUQR>().isDone ==
                                          false
                                      ? InkWell(
                                          onTap: () {
                                            context
                                                .read<ChangeNotifierHUQR>()
                                                .setPosition(true);
                                          },
                                          child: Icon(
                                              size: 17,
                                              IconBroken.Arrow___Right_2))
                                      : InkWell(
                                          onTap: () {
                                            context
                                                .read<ChangeNotifierHUQR>()
                                                .setPosition(false);
                                          },
                                          child: Icon(
                                              size: 17,
                                              IconBroken.Arrow___Down_2))),
                        ),
                        if (context.read<ChangeNotifierHUQR>().isDone)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Course ID ${model.courseId}'),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text('Building ${classRoomInfo[0]}'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Room ID ${classRoomInfo[1]}'),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('ERROR');
          } else {
            return Text('reload');
          }
        });
  }
}
