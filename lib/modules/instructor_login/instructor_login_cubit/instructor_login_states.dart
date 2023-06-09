
abstract class InstructorLoginStates {}

class InstructorLoginInitialState extends InstructorLoginStates{}

class InstructorLoginLoadingState extends InstructorLoginStates{}

class InstructorLoginSuccessState extends InstructorLoginStates{
final String uId;
InstructorLoginSuccessState({
  required this.uId,
});
}

class InstructorLoginErrorState extends InstructorLoginStates{
  final String error;
  InstructorLoginErrorState({required this.error});
}

class InstructorChangePasswordVisibilityState extends InstructorLoginStates{}