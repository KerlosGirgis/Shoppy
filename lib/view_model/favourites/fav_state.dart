abstract class FavState{
  const FavState();

  List<Object> get props => [];

}

class FavInitial extends FavState{}
class FavLoading extends FavState{}
class FavSuccess extends FavState{
  final List<String> favs;
  FavSuccess(this.favs);
}
class FavError extends FavState{
  final String error;
  FavError({required this.error});
}
class FavEmpty extends FavState{}
