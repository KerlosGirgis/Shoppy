import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/view/screens/product.dart';
import 'package:shoppy/view_model/product/product_cubit.dart';

import '../../theme/theme.dart';
import '../../view_model/category/category_cubit.dart';
import '../../view_model/category/category_state.dart';
import '../../view_model/favourites/fav_cubit.dart';
import '../../view_model/favourites/fav_state.dart';
import '../../view_model/product/product_state.dart';
import '../../view_model/theme_cubit.dart';
import 'category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryCubit>(context).getCategories();
    BlocProvider.of<ProductCubit>(context).getProducts();
    BlocProvider.of<FavCubit>(context).getFavourites();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return Scaffold(
          backgroundColor: appTheme.backgroundColor,
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 1.1,
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            context.read<ProductCubit>().filterProducts(value);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: appTheme.textLD,
                            ),
                            hintText: "Search",
                            hintStyle: TextStyle(color: appTheme.textLD),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                context.read<ProductCubit>().filterProducts('');
                              },
                              icon: Icon(Icons.clear, color: appTheme.textLD),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: appTheme.cardBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 32)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is CategoryError) {
                            return Center(
                              child: Text('Error: ${state.message}'),
                            );
                          } else if (state is CategoryLoaded) {
                            return SizedBox(
                              width: MediaQuery.sizeOf(context).width / 1.1,
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.categories.length,
                                itemBuilder: (context, index) {
                                  final category = state.categories[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryPage(
                                            categoryId: category.id,
                                            categoryName: category.name,
                                          ),
                                        ),
                                      ).then((value) {
                                        if (context.mounted) {
                                          BlocProvider.of<ProductCubit>(
                                            context,
                                          ).getProducts();
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      category.image,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withAlpha(100),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                              ),
                                              Hero(
                                                tag: category.id,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    category.name,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: appTheme.textLD,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('Tap to load categories'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ProductError) {
                            return Center(
                              child: Text('Error: ${state.message}'),
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
                                physics: NeverScrollableScrollPhysics(),
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
                                                        ProductPage(
                                                          product: product,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 200,
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  color:
                                                      appTheme.cardBackground,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(23),
                                                        topRight:
                                                            Radius.circular(23),
                                                      ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      product.imageCover,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withAlpha(100),
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
                                                          if (state
                                                              is FavSuccess) {
                                                            if (state.favs
                                                                .contains(
                                                                  product.id,
                                                                )) {
                                                              return IconButton(
                                                                onPressed: () {
                                                                  BlocProvider.of<
                                                                        FavCubit
                                                                      >(context)
                                                                      .removeFav(
                                                                        product
                                                                            .id,
                                                                      );
                                                                },
                                                                icon: const Icon(
                                                                  Icons
                                                                      .favorite_rounded,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              );
                                                            }
                                                          }
                                                          return IconButton(
                                                            onPressed: () {
                                                              BlocProvider.of<
                                                                    FavCubit
                                                                  >(context)
                                                                  .addFav(
                                                                    product.id,
                                                                  );
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
                                                  bottomLeft: Radius.circular(
                                                    23,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    23,
                                                  ),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withAlpha(100),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
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
                                                              color: appTheme
                                                                  .textLD,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                            color:
                                                                appTheme.textLD,
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
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
