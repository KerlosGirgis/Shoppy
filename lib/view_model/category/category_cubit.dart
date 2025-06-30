import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {

  CategoryCubit() : super(CategoryInitial());

  ApiService apiService = ApiService();
  Future<void> getCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await apiService.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}