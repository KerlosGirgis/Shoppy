import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/theme/theme.dart';
import 'package:shoppy/view/screens/cart.dart';
import 'package:shoppy/view/screens/favourites.dart';
import 'package:shoppy/view/screens/home.dart';
import 'package:shoppy/view/screens/profile.dart';

import '../../view_model/theme_cubit.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}


class _NavbarState extends State<Navbar> {

  late final PageController _pageController;
  late final NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _controller = NotchBottomBarController(index: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return Scaffold(
          backgroundColor: appTheme.backgroundColor,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomePage(),
              FavouritesPage(),
              CartPage(),
              ProfilePage(),
            ],
          ),
          extendBody: true,
          bottomNavigationBar:
              AnimatedNotchBottomBar(
                  notchBottomBarController: _controller,
                  color: appTheme.accentColor,
                  showLabel: false,
                  bottomBarWidth: MediaQuery.sizeOf(context).width / 1,
                  textOverflow: TextOverflow.visible,
                  maxLine: 1,
                  shadowElevation: 5,
                  kBottomRadius: 28.0,
                  notchColor: Colors.white,
                  removeMargins: false,
                  showShadow: true,
                  durationInMilliSeconds: 300,
                  itemLabelStyle: const TextStyle(fontSize: 10),
                  elevation: 1,
                  bottomBarItems: [
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.home_outlined,
                        color: appTheme.textLD,
                      ),
                      activeItem: Icon(
                        Icons.home_filled,
                        color: Colors.blueAccent,
                      ),
                      itemLabel: '',
                    ),
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.favorite_outline_sharp,
                        color: appTheme.textLD,
                      ),
                      activeItem: Icon(Icons.favorite_sharp, color: Colors.red),
                      itemLabel: '',
                    ),
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.shopping_bag_outlined,
                        color: appTheme.textLD,
                      ),
                      activeItem: Icon(Icons.shopping_bag, color: Colors.green),
                      itemLabel: '',
                    ),
                    BottomBarItem(
                      inActiveItem: Icon(
                        Icons.person_outline,
                        color: appTheme.textLD,
                      ),
                      activeItem: Icon(Icons.person, color: Colors.redAccent),
                      itemLabel: '',
                    ),
                  ],
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                  },
                  kIconSize: 24.0,
                )

        );
      },
    );
  }
}
