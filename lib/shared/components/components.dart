import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_project/shared/styles/colors.dart';

enum ToastStates { SUCCESS, WARNING, ERROR }

Widget defaultButton({
  required VoidCallback? function,
  required String text,
  double width = double.infinity,
  double height = 40.0,
  bool isUpperCase = true,
  double radius = 0.0,
  double padding = 10,
}) =>
    Container(
      key: GlobalKey(),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: defaultColor,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: MaterialButton(
        padding: EdgeInsets.all(padding),
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback func,
  required String text,
  required context,
}) =>
    TextButton(
      onPressed: func,
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );

void showToast({
  required text,
  required ToastStates state,
  dynamic context,
}) =>
    Fluttertoast.showToast(
      msg: text as String,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state: state),
      textColor: Theme.of(context).textTheme.bodySmall?.color,
      fontSize: 16.0,
    );

Color chooseToastColor({required ToastStates state}) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

Widget defaultFormField({
  required TextEditingController? controller,
  required TextInputType? type,
  required String? label,
  required IconData? prefix,
  bool obsecure = false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  required FormFieldValidator? valid,
  VoidCallback? onTap,
  bool isClickable = true,
  ValueChanged<String>? onChange,
  ValueChanged<String>? onSubmit,
  double radius = 30,
}) =>
    TextFormField(
      enabled: isClickable,
      controller: controller,
      onFieldSubmitted: onSubmit,
      validator: valid,
      onChanged: onChange,
      keyboardType: type,
      obscureText: obsecure,
      decoration: InputDecoration(
          labelText: label,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
          focusColor: Colors.pinkAccent,
          fillColor: Colors.pink,
          hoverColor: Colors.pinkAccent,
          prefixIcon: Icon(
            prefix,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                  icon: Icon(suffix),
                  onPressed: suffixPressed,
                )
              : null),
      onTap: onTap,
    );

Widget myDividor() => Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    );

Future<void> navigateTo({
  required context,
  required widget,
}) =>
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateBack({
  required context,
}) =>
    Navigator.pop(context);

void navigateAndReplace({
  required context,
  required widget,
}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
