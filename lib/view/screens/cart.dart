import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/theme/theme.dart';
import 'package:shoppy/view_model/cart/cart_state.dart';
import 'package:shoppy/view_model/theme_cubit.dart';
import '../../view_model/cart/cart_cubit.dart';
import '../../view_model/product/product_cubit.dart';
import '../../view_model/product/product_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    BlocProvider.of<ProductCubit>(context).getList(
        await BlocProvider.of<CartCubit>(context).getCart().then((value){
      return value.map((item) => item["id"]?.toString())
          .whereType<String>()
          .toList();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: appTheme.backgroundColor,
            appBar: AppBar(
              title: Text(
                'Cart',
                style: TextStyle(
                  color: appTheme.textLD,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: appTheme.backgroundColor,
            ),
            body: BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                if (cartState is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (cartState is CartEmpty) {
                  return Center(
                    child: Image.asset("assets/pics/empty_cart.png"),
                  );
                }
                if (cartState is CartSuccess) {
                  return BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } if (state is ProductError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      if (state is ProductEmpty){
                        return Center(child: Image.asset("assets/pics/empty_cart.png"));
                      }
                      if (state is ProductLoaded) {
                        return ListView.builder(
                          itemCount: cartState.items.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartState.items[index];
                            final productId = cartItem["id"];
                            final quantity = cartItem["quantity"];
                            final product = state.products.firstWhere(
                                  (p) => p.id == productId,
                            );
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: appTheme.cardBackground,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.network(
                                        product.imageCover,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: appTheme.textLD,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.description
                                                .replaceAll('\t', ' ')
                                                .replaceAll('\n', ' '),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${product.price}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: appTheme.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    BlocProvider.of<CartCubit>(
                                                      context,
                                                    ).removeOneFromCart(product.id);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: appTheme.primaryColor,
                                                    shape: const CircleBorder(),
                                                    padding: const EdgeInsets.all(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  quantity.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: appTheme.textLD,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 32,
                                                height: 32,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    BlocProvider.of<CartCubit>(
                                                      context,
                                                    ).addToCart(product.id, 1);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: appTheme.primaryColor,
                                                    shape: const CircleBorder(),
                                                    padding: const EdgeInsets.all(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                          child: Text(
                            'No products in the cart.',
                            style: TextStyle(
                              color: appTheme.textLD,
                              fontSize: 18,
                            ),
                          ),
                        );
                    },
                  );
                }
                if (cartState is CartError) {
                  return Center(
                    child: Text('Error from cart: ${cartState.error}'),
                  );
                }
          
                return Center(
                  child: IconButton(
                    onPressed: () {
                      BlocProvider.of<CartCubit>(context).getCart();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                );
              },
            ),
          
          
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      backgroundColor: appTheme.primaryColor,
                      onPressed: (){},
                      child: Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                      )),
                  Padding(padding: EdgeInsets.only(bottom: 0))
                ]
            ),
          
          ),
        );
      },
    );
  }
}
