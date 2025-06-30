import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/view/screens/navbar.dart';
import 'package:shoppy/view/screens/register.dart';
import 'package:shoppy/view_model/auth/auth_cubit.dart';
import 'package:shoppy/view_model/auth/auth_state.dart';

import '../../core/utils/form_validator.dart';
import '../../theme/theme.dart';
import '../../view_model/theme_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDialogVisible = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).clearErrors();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (BuildContext context, state) {
            if (state is AuthLoading && !_isDialogVisible) {
              _isDialogVisible = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              ).then((_) {
                _isDialogVisible = false;
              });
            }
            if (state is AuthError) {
              if (_isDialogVisible) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              );
            }

            if (state is AuthSuccess) {
              if (_isDialogVisible) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Navbar()),
                    (route) => false,
              );
            }
          },
          child: Scaffold(
            backgroundColor: appTheme.backgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.sizeOf(context).height / 7,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Sign in",
                            style: TextStyle(
                              fontFamily: "Circular Std",
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: appTheme.textLD,
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 32)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.2,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: FormValidator.validateEmail,
                              controller: _emailController,
                              style: TextStyle(
                                color: appTheme.textLD,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_rounded,
                                  color: appTheme.textLD,
                                ),
                                prefixIconColor: appTheme.textLD,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: appTheme.textLD,
                                ),
                                filled: true,
                                fillColor: appTheme.cardBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.2,
                            child: TextFormField(
                              validator: FormValidator.validatePassword,
                              controller: _passwordController,
                              style: TextStyle(
                                color: appTheme.textLD,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock_rounded,
                                  color: appTheme.textLD,
                                ),
                                prefixIconColor: appTheme.textLD,
                                hintStyle: TextStyle(
                                  color: appTheme.textLD,
                                ),
                                filled: true,
                                fillColor: appTheme.cardBackground,
                              ),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.2,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthCubit>(context).signIn(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                                else{
                                  BlocProvider.of<AuthCubit>(context).clearErrors();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Invalid email or password"),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontFamily: "Circular Std",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appTheme.textLD,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                fontFamily: "Circular Std",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: appTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 32)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 1.2,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthCubit>(context).signInWithGoogle();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appTheme.cardBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(flex: 3),
                                  Image.asset(
                                    "assets/icons/google.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  Spacer(flex: 1),
                                  Text(
                                    "Continue With Google",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: appTheme.textLD,
                                    ),
                                  ),
                                  Spacer(flex: 3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 32)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
