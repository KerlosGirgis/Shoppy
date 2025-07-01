import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppy/core/utils/form_validator.dart';
import 'package:shoppy/view/screens/login.dart';
import 'package:shoppy/view/screens/navbar.dart';

import '../../theme/theme.dart';
import '../../view_model/auth/auth_cubit.dart';
import '../../view_model/auth/auth_state.dart';
import '../../view_model/theme_cubit.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).clearErrors();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, appTheme) {
        return BlocListener<AuthCubit, AuthState>(
          bloc: context.read<AuthCubit>(),
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
                            "Create Account",
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
                              validator: FormValidator.validateName,
                              controller: _firstNameController,
                              style: TextStyle(color: appTheme.textLD),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'First Name',
                                hintStyle: TextStyle(color: appTheme.textLD),
                                prefixIcon: Icon(
                                  Icons.person,
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
                              validator: FormValidator.validateName,
                              controller: _lastNameController,
                              style: TextStyle(color: appTheme.textLD),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Last Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: appTheme.textLD,
                                ),
                                hintStyle: TextStyle(color: appTheme.textLD),
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
                              validator: FormValidator.validateEmail,
                              controller: _emailController,
                              style: TextStyle(color: appTheme.textLD),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: appTheme.textLD,
                                ),
                                hintStyle: TextStyle(color: appTheme.textLD),
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
                              style: TextStyle(color: appTheme.textLD),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: appTheme.textLD,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: isPasswordVisible
                                      ? Icon(
                                          Icons.visibility,
                                          color: appTheme.textLD,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: appTheme.textLD,
                                        ),
                                ),
                                hintStyle: TextStyle(color: appTheme.textLD),
                                filled: true,
                                fillColor: appTheme.cardBackground,
                              ),
                              obscureText: !isPasswordVisible,
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
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Please Enter Valid Values",
                                      ),
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
                                "Sign Up",
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
                            "Already have an account?",
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
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          listener: (BuildContext context, state) {
            if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Navbar()),
                (route) => false,
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
