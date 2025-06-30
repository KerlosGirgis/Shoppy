import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/theme/theme.dart';
import 'package:shoppy/view/screens/product.dart';
import 'package:shoppy/view_model/favourites/fav_cubit.dart';
import 'package:shoppy/view_model/theme_cubit.dart';

import '../../view_model/favourites/fav_state.dart';
import '../../view_model/product/product_cubit.dart';
import '../../view_model/product/product_state.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavCubit>(context).getFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Scaffold(
            backgroundColor: appTheme.backgroundColor,
            appBar: AppBar(
              backgroundColor: appTheme.backgroundColor,
              surfaceTintColor: appTheme.backgroundColor,
              title: Text(
                'Favourites',
                style: TextStyle(
                  color: appTheme.textLD,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            body: BlocBuilder<FavCubit, FavState>(
              builder: (context, state) {
                if (state is FavLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FavSuccess) {
                  BlocProvider.of<ProductCubit>(context).getList(state.favs);
                  return BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is ProductEmpty) {
                        return Center(
                          child: Image.asset("assets/pics/empty_favourites.png"),
                        );
                      } else if (state is ProductLoaded) {
                        return SizedBox(
                          width:
                              MediaQuery.orientationOf(context) ==
                                  Orientation.portrait
                              ? MediaQuery.sizeOf(context).width / 1
                              : MediaQuery.sizeOf(context).width / 1.1,
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return Hero(
                                transitionOnUserGestures: true,
                                tag: product.id,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductPage(product: product),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 200,
                                            height: 250,
                                            decoration: BoxDecoration(
                                              color: appTheme.cardBackground,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(23),
                                                topRight: Radius.circular(23),
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  product.imageCover,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withAlpha(
                                                    100,
                                                  ),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: BlocBuilder<FavCubit, FavState>(
                                                    builder: (context, state) {
                                                      if (state is FavSuccess) {
                                                        if (state.favs.contains(
                                                          product.id,
                                                        )) {
                                                          return IconButton(
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                    FavCubit
                                                                  >(context)
                                                                  .removeFav(
                                                                    product.id,
                                                                  );
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .favorite_rounded,
                                                              color: Colors.red,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                      return IconButton(
                                                        onPressed: () {
                                                          BlocProvider.of<
                                                                FavCubit
                                                              >(context)
                                                              .addFav(product.id);
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .favorite_border_rounded,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: appTheme.cardBackground,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(23),
                                              bottomRight: Radius.circular(23),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withAlpha(100),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        product.title,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: appTheme.textLD,
                                                        ),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '\$${product.price}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: appTheme.textLD,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.orientationOf(context) ==
                                          Orientation.portrait
                                      ? 2
                                      : 4,
                                  childAspectRatio:
                                      MediaQuery.orientationOf(context) ==
                                          Orientation.portrait
                                      ? .6
                                      : .6,
                                ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text('Tap to load categories'),
                        );
                      }
                    },
                  );
                }
                if (state is FavError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                if (state is FavEmpty) {
                  return Center(
                    child: Image.asset("assets/pics/empty_favourites.png"),
                  );
                }
                return Center(
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<FavCubit>(context).getFavourites();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
