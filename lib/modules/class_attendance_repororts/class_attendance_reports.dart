import 'package:flutter/material.dart';
import 'package:graduation_project/layouts/instructor_layout/instructor_cubit/instructor_layout_cubit.dart';
import 'package:graduation_project/modules/Pdf/pdf.dart';
import 'package:graduation_project/shared/styles/colors.dart';
import 'package:graduation_project/shared/styles/icon_broken.dart';

class ClassAttendanceReports extends StatelessWidget {
  ClassAttendanceReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: InstructorLayoutCubit.get(context).getAvailableLists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                // print(snapshot.data?.docs.elementAt(0).data());
                if (snapshot.data!.docs.length > 0) {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildListItem(
                            context: context,
                            snapshot: snapshot.data?.docs.elementAt(index),
                            index: index);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: snapshot.data!.docs.length);
                } else {
                  return Center(child: Text('no lists'));
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('error'));
              } else {
                print('NULLLLLLLLLLLLLL');
                return Center(child: Text('no lists'));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildListItem({
    required context,
    required snapshot,
    required index})=>StreamBuilder(
    stream: InstructorLayoutCubit.get(context)
        .getCourseName(InstructorLayoutCubit.get(context)
        .classInfoModel
        ?.courseId as String),
    builder: (context, snapshot2) {
      if (snapshot2.connectionState ==
          ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot2.hasData) {
        return Dismissible(
          key: Key('deleteList'),
          direction: DismissDirection.startToEnd,
          background: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(IconBroken.Delete), Text('Delete')],
                ),
              ),
            ),
            color: Colors.red,
          ),
          onDismissed: (direction){
            InstructorLayoutCubit.get(context).deleteList(snapshot.id);
          },
          child: InkWell(
            onTap: () async {
              showDialog(
                context: InstructorLayoutCubit.get(context)
                    .contextLayout,
                builder: (context) {
                  return FutureBuilder(
                      future: InstructorLayoutCubit.get(
                          context)
                          .getAttendanceList(),
                      builder: (context, snapshot3) {
                        if(snapshot3.connectionState==ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot3.data?.length==0){
                          return Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child:
                              Column(
                                children: [
                                  CircularProgressIndicator(color: defaultColor,),
                                  Text('No Students In Class',style: Theme.of(context).textTheme.bodySmall,),
                                ],
                              ));
                        } else {
                          List<List<dynamic>> data =
                          snapshot3.data!
                              .map((e) => [
                            '${e.attendedByClassModel!.studentRegisterModel!.id}',
                            '${e.attendedByClassModel!.studentRegisterModel!.firstName}',
                            '${e.attendedByClassModel!.studentRegisterModel!.middleName}',
                            '${e.attendedByClassModel!.studentRegisterModel!.lastName}',
                            '${e.attendedByClassModel?.absenceDays}',
                            '${e.attended == false ? 'No' : 'Yes'}'
                          ])
                              .toList();

                          return FutureBuilder(
                            future: InstructorLayoutCubit
                                .get(context)
                                .generateText(
                                '${DateTime.now().day}-', data),
                            builder: (context, snapshot4) {
                              if (snapshot4
                                  .connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot4.hasData) {
                                return Container(
                                  child: Column(
                                    children: [
                                      AppBar(
                                        leading: IconButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context);
                                            },
                                            icon: Icon(
                                                IconBroken
                                                    .Arrow___Left_2)),
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors
                                            .grey[500],
                                      ),
                                      Expanded(
                                        child: PageView
                                            .builder(
                                          itemBuilder: (context,
                                              index) =>
                                              PdfClass(
                                                  data: snapshot4
                                                      .data),
                                          itemCount: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot4
                                  .hasError) {
                                return Text('PDF ERROR');
                              } else {
                                return Text('No PDF');
                              }
                            },
                          );
                        }
                      });
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10),
                      color: Color(
                          InstructorLayoutCubit.get(context)
                              .classInfoModel
                              ?.color as int),
                    ),
                    child: Center(
                      child: Text(
                          '${snapshot2.data![0]}${snapshot2.data![snapshot2.data!.length - 1]}'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      '${snapshot.data()['classDate']}'),
                ],
              ),
            ),
          ),
        );
      } else if (snapshot2.hasError) {
        print(snapshot2.error);
        return Center(child: Text('Error'));
      } else {
        return Center(child: Text('No Name'));
      }
    },
  );
}
