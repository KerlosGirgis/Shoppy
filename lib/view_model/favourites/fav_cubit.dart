import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/services/fav_service.dart';
import 'package:shoppy/view_model/favourites/fav_state.dart';

class FavCubit extends Cubit<FavState>{
  FavCubit() : super(FavInitial());
  static FavCubit get(context) => BlocProvider.of(context);

  FavService favService = FavService();

  List<String> favourites = [];

  Future<List<String>> getFavourites() async {
    emit(FavLoading());
    favourites = await favService.getFavs();
    if(favourites.isEmpty){
      emit(FavEmpty());
      return favourites;
    }
    else{
      emit(FavSuccess(favourites));
      return favourites;
    }
  }

  void addFav(String id){
    favService.addFav(id).then((value) {
      favourites.add(id);
      emit(FavSuccess(favourites));
    }).catchError((error){
      emit(FavError(error: error.toString()));
    });
  }
  void removeFav(String id){
    favService.removeFav(id).then((value) {
      favourites.remove(id);
      emit(FavSuccess(favourites));
    }).catchError((error){
      emit(FavError(error: error.toString()));
    });
  }
  bool isFav(String id){
    if(favourites.contains(id)){
      return true;
    }else{
      return false;
    }
  }

  void toggleFav(String id){
    if(isFav(id)){
      removeFav(id);
    }else{
      addFav(id);
    }
  }

}