import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/view_model/product/product_cubit.dart';

import '../../theme/theme.dart';
import '../../view_model/orders/orders_cubit.dart';
import '../../view_model/orders/orders_state.dart';
import '../../view_model/product/product_state.dart';
import '../../view_model/theme_cubit.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrdersCubit>(context).getOrders();
    BlocProvider.of<ProductCubit>(context).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return Scaffold(
          backgroundColor: appTheme.backgroundColor,
          appBar: AppBar(
            surfaceTintColor: appTheme.backgroundColor,
            backgroundColor: appTheme.backgroundColor,
            title: Text(
              'Orders',
              style: TextStyle(
                color: appTheme.textLD,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: appTheme.textLD,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.cardBackground,
              ),
            ),
          ),
          body: BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              if (state is OrdersLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is OrdersLoaded) {
                return BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, productState) {
                    if (productState is ProductLoaded) {
                      return ListView.builder(
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23),
                            ),
                            shadowColor: appTheme.textLD,
                            color: appTheme.cardBackground,
                            child: ListTile(
                              title: Text(
                                'Order ID: #$index',
                                style: TextStyle(
                                  color: appTheme.textLD,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date: ${order['timestamp'].toDate()}',
                                    style: TextStyle(
                                      color: appTheme.textLD,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Items:',
                                    style: TextStyle(
                                      color: appTheme.textLD,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: order['items'].map<Widget>((
                                      item,
                                    ) {
                                      final productId = item['id'];
                                      final quantity = item['quantity'];
                                      final product = productState.products
                                          .firstWhere((p) => p.id == productId);
                                      return Row(
                                        children: [
                                          Text(
                                            '${product.title.substring(0, product.title.length < 20 ? product.title.length : 30)} x$quantity',
                                            style: TextStyle(
                                              color: appTheme.textLD,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
              return Center(
                child: Text(
                  'No orders found',
                  style: TextStyle(
                    color: appTheme.textLD,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
