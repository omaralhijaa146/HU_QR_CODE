import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_cubit.dart';
import 'package:graduation_project/layouts/student_layout/student_cubit/student_Layout_states.dart';
import 'package:graduation_project/models/display_classes_model/display_classes_model.dart';
import 'package:graduation_project/models/student_register_model/student_register_model.dart';
import 'package:graduation_project/shared/components/qr_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrCode extends StatelessWidget {
  DisplayClassesModel model;
  StudentRegisterModel studentRegisterModel;

  ScanQrCode(this.model, this.studentRegisterModel);

  MobileScannerController mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentLayoutCubit(),
      child: BlocConsumer<StudentLayoutCubit, StudentLayoutStates>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
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
                          /*print(
                              'QR CODE&*&*&*&*&*&*&*&*&*+++++  ${barcode.barcodes[0].rawValue as String}');
                          mobileScannerController.stop().then((value) {
                              child: CheckStudentClassInfo(
                                  barcode.barcodes[0].rawValue as String,
                                  studentRegisterModel,
                                  model.classInfoModel as ClassInfoModel),
                            );
                            navigateTo(
                                context: context,
                                widget: CheckStudentClassInfo(
                                    barcode.barcodes[0].rawValue as String,
                                    studentRegisterModel,
                                    model.classInfoModel as ClassInfoModel));
                          });
*/
                          /* StudentLayoutCubit.get(context).checkIfAttended(
                              model, barcode.rawValue as String);*/
                          /* if (barcode.rawValue ==
                              model.classInfoModel?.courseId) {
                           */ /* StudentLayoutCubit.get(context)
                                .checkIfAttended(
                                    model, barcode.rawValue as String)
                                .then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentLayout(),
                                  ),
                                  (route) => false);
                            });*/ /*
                          }*/
                          //StudentLayoutCubit.get(context).checkIfAttended(model," ");
                          print(
                              "************************************************");
                          // TimeOfDay.now();
                          // String timeNow=TimeOfDay.now().format(context);
                          // print(timeNow);
                          // StudentLayoutCubit.get(context).checkIfAttended(model,
                          //     barcode.rawValue as String);
                          print(
                              "**************************************************");
                        },
                        controller: mobileScannerController,
                      ),
                      QRScannerOverlay(
                        overlayColour: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
