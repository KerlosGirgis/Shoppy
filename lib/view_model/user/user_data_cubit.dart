import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_data_state.dart';
import '../../services/user_service.dart';

class UserDataCubit extends Cubit<UserDataState> {
  final UserService userService;

  UserDataCubit({required this.userService}) : super(UserDataInitial());

  Future<void> fetchUserData() async {
    emit(UserDataLoading());
    try {
      final userData = await userService.getUserData();
      emit(UserDataLoaded(
        fName: userData['fName'] ?? '',
        lName: userData['lName'] ?? '',
      ));
    } catch (e) {
      emit(UserDataError(message: e.toString()));
    }
  }
}
