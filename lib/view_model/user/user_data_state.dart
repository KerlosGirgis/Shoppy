abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final String fName;
  final String lName;

  UserDataLoaded({required this.fName, required this.lName});
}

class UserDataError extends UserDataState {
  final String message;

  UserDataError({required this.message});
}
