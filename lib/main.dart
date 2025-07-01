import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/services/auth_service.dart';
import 'package:shoppy/services/user_service.dart';
import 'package:shoppy/theme/theme.dart';
import 'package:shoppy/view/screens/login.dart';
import 'package:shoppy/view/screens/navbar.dart';
import 'package:shoppy/view_model/auth/auth_cubit.dart';
import 'package:shoppy/view_model/auth/auth_state.dart';
import 'package:shoppy/view_model/cart/cart_cubit.dart';
import 'package:shoppy/view_model/category/category_cubit.dart';
import 'package:shoppy/view_model/favourites/fav_cubit.dart';
import 'package:shoppy/view_model/orders/orders_cubit.dart';
import 'package:shoppy/view_model/product/product_cubit.dart';
import 'package:shoppy/view_model/theme_cubit.dart';
import 'package:shoppy/view_model/user/user_data_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(create: (context) => CategoryCubit()),
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => FavCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => OrdersCubit()),
        BlocProvider(
          create: (context) => AuthCubit(authService: AuthService()),
        ),
        BlocProvider(
          create: (context) => UserDataCubit(userService: UserService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, themeState) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Navbar();
              }
              return LoginPage(); // Handles AuthUnauthenticated
            },
          ),
        );
      }
    );
  }
}
