import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/view_model/favourites/fav_cubit.dart';
import 'package:shoppy/view_model/quantity/quantity_cubit.dart';
import 'package:shoppy/view_model/theme_cubit.dart';

import '../../models/product.dart';
import '../../theme/theme.dart';
import '../../view_model/cart/cart_cubit.dart';
import '../../view_model/cart/cart_state.dart';
import '../../view_model/favourites/fav_state.dart';
import '../../view_model/quantity/quantity_state.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});
  final Product product;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  @override
  void initState() {
    BlocProvider.of<FavCubit>(context).getFavourites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return BlocProvider(
          create: (context) => QuantityCubit(widget.product.price),
          child: Scaffold(
            backgroundColor: appTheme.backgroundColor,
            appBar: AppBar(
              surfaceTintColor: appTheme.backgroundColor,
              backgroundColor: appTheme.backgroundColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_rounded,color: appTheme.textLD),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.cardBackground,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: BlocBuilder<FavCubit, FavState>(
                    builder: (context, state) {
                      if (state is FavSuccess) {
                        if(state.favs.contains(widget.product.id)){
                          return IconButton(
                            onPressed: () {
                              BlocProvider.of<FavCubit>(context).removeFav(widget.product.id);
                            },
                            icon: const Icon(Icons.favorite_rounded,color: Colors.red,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appTheme.cardBackground,
                            ),
                          );
                        }
                      }
                      return IconButton(
                        onPressed: () {
                          BlocProvider.of<FavCubit>(context).addFav(widget.product.id);
                        },
                        icon: Icon(Icons.favorite_border_rounded,color: appTheme.textLD),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.cardBackground,
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                      transitionOnUserGestures: true,
                      tag: widget.product.id,
                      child: Material(
                        color: Colors.transparent,
                        child: CarouselSlider.builder(
                          itemCount: widget.product.images.length,
                          itemBuilder: (context, index, realIndex) {
                            return Image.network(
                              widget.product.images[index],
                              fit: BoxFit.cover,
                            );
                          },
                          options: CarouselOptions(
                            height: MediaQuery.sizeOf(context).height / 2.5,
                            viewportFraction: 1,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.1,
                            child: Text(
                              widget.product.title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: appTheme.textLD,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '\$${widget.product.price}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: appTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: BlocBuilder<QuantityCubit,QuantityState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width / 1.1,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: appTheme.cardBackground,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Quantity",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: appTheme.textLD,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Spacer(flex: 1),
                                      IconButton(
                                        onPressed: () {
                                          BlocProvider.of<QuantityCubit>(context).decrement();

                                        },
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: appTheme.primaryColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          state.quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: appTheme.textLD,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          BlocProvider.of<QuantityCubit>(context).increment();

                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: appTheme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.1,
                            child: Text(
                              widget.product.description
                                  .split("\t")
                                  .join(" ")
                                  .split("\n")
                                  .join(" "),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 2,
              color: appTheme.backgroundColor,
              child: BlocBuilder<QuantityCubit,QuantityState>(
                builder: (context, quantityState) {
                  return BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      return ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<CartCubit>(context).addToCart(
                            widget.product.id,
                            quantityState.quantity,
                          ).then((v){
                            if(context.mounted){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added to cart"),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              );
                              BlocProvider.of<QuantityCubit>(context).reset();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              quantityState.totalPrice.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(flex: 1),
                            Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  );
                }
              ),
            ),
          ),
        );
      },
    );
  }
}
