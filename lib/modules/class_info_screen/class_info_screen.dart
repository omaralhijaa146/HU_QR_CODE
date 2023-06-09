import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_states.dart';
import 'package:graduation_project/models/class_info_model/class_info_model.dart';
import 'package:graduation_project/shared/components/components.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class ClassInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstructorLayoutCubit, InstructorLayoutStates>(
      builder: (context2, state) {
        ClassInfoModel model =
            InstructorLayoutCubit.get(context).classInfoModel as ClassInfoModel;

        return Column(
          children: [
            SizedBox(
              height: 110,
            ),
            Center(
                child: Icon(
              Icons.qr_code_rounded,
              size: 200,
            )),
            SizedBox(
              height: 40,
            ),
            defaultButton(
                radius: 10,
                width: 220,
                function: () {
                  showDialog(
                    context: context,
                    builder: (context) => Center(
                      child: Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Screenshot(
                                controller: InstructorLayoutCubit.get(context2)
                                    .screenshotController,
                                child: QrImageView(
                                  data: "${model.uId}",
                                  size: 250,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                    child: Icon(
                                      Icons.download,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      InstructorLayoutCubit.get(context2)
                                          .captureAndSaveQRCode(context2);
                                      /* screenshotController
                                                .capture(
                                                delay: const Duration(
                                                    milliseconds: 10))
                                                .then((image) async {
                                              if (image != null) {
                                                Uint8List image2 = image;
                                                var storagePath =
                                                await getExternalStorageDirectory();
                                                final imagePath = await File(
                                                    '${storagePath
                                                        ?.path}/${DateTime
                                                        .now()}_${TimeOfDay.now()
                                                        .format(context)}.png');
                                                await imagePath
                                                    .writeAsBytes(image2);
                                                print(imagePath);
                                                GallerySaver.saveImage(
                                                    imagePath.path,
                                                    albumName: "myApp")
                                                    .then((value) {
                                                  if (value == true)
                                                    print(
                                                        "************SAVED************");
                                                });
                                              }
                                            });*/
                                    }),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                text: "generate qr code"),
          ],
        );
      },
      listener: (context, state) {},
    );
    ;
  }
}
