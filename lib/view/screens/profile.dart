import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/theme/theme.dart';
import 'package:shoppy/view/screens/login.dart';
import 'package:shoppy/view_model/theme_cubit.dart';

import '../../view_model/auth/auth_cubit.dart';
import '../../view_model/user/user_data_cubit.dart';
import '../../view_model/user/user_data_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  @override
  void initState() {
    super.initState();
    context.read<UserDataCubit>().fetchUserData();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: appTheme.backgroundColor,
            appBar: AppBar(backgroundColor: appTheme.backgroundColor,
            surfaceTintColor: appTheme.backgroundColor,),
            body: SingleChildScrollView(
              child: BlocBuilder<UserDataCubit, UserDataState>(
                builder: (context,userState) {
                  if(userState is UserDataLoaded) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [appTheme.textLD, appTheme.primaryColor],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: appTheme.primaryColor.withAlpha(125),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  userState.fName[0].toUpperCase(),
                                  style: TextStyle(
                                    color: appTheme.backgroundColor,
                                    fontSize: 60,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${userState.fName} ${userState.lName}",
                              style: TextStyle(
                                color: appTheme.textLD,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 16, left: 16),
                                child: ElevatedButton(

                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    backgroundColor: appTheme.cardBackground,
                                    elevation: 2,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.history_rounded, color: appTheme.textLD, size: 26),
                                        Padding(padding: EdgeInsets.only(right: 10)),
                                        Text(
                                          "Orders",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: appTheme.textLD,
                                          ),
                                        ),
                                        Spacer(flex: 1),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 28,
                                          color: appTheme.textLD,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 16, left: 16),
                                child: ElevatedButton(

                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    backgroundColor: appTheme.cardBackground,
                                    elevation: 2,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: appTheme.textLD, size: 26),
                                        Padding(padding: EdgeInsets.only(right: 10)),
                                        Text(
                                          "Addresses",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: appTheme.textLD,
                                          ),
                                        ),
                                        Spacer(flex: 1),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 28,
                                          color: appTheme.textLD,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 16, left: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<ThemeCubit>().toggleTheme();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    backgroundColor: appTheme.cardBackground,
                                    elevation: 2,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.dark_mode_outlined, color: appTheme.textLD, size: 26),
                                        Padding(padding: EdgeInsets.only(right: 10)),
                                        Text(
                                          "Dark Mode",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: appTheme.textLD,
                                          ),
                                        ),
                                        Spacer(flex: 1),
                                        Switch(
                                          value: appTheme.isDark,
                                          onChanged: (value) {
                                            context.read<ThemeCubit>().toggleTheme();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 16, left: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<AuthCubit>(context).signOut();
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  elevation: 2,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout_rounded, color: appTheme.textLD, size: 26),
                                      Padding(padding: EdgeInsets.only(right: 10)),
                                      Text(
                                        "Sign Out",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: appTheme.textLD,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  else if(userState is UserDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if(userState is UserDataError) {
                    return Center(
                      child: Text(userState.message),
                    );
                  }
                  else {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                }
              ),
            ),
          ),
        );
      },
    );
  }
}
