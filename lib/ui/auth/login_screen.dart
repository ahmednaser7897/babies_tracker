import 'package:babies_tracker/app/app_strings.dart';
import 'package:babies_tracker/ui/hospital/hospital_main_screen.dart';
import 'package:babies_tracker/ui/mother/moher_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:babies_tracker/app/app_assets.dart';
import 'package:babies_tracker/app/app_sized_box.dart';
import 'package:babies_tracker/app/app_validation.dart';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/ui/admin/admin_main_screen.dart';

import '../../controller/auth/auth_cubit.dart';
import '../componnents/const_widget.dart';
import '../componnents/show_flutter_toast.dart';

import '../doctor/doctor_main_screen.dart';
import 'widgets/build_auth_bottom.dart';
import 'widgets/build_text_form_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = 'ahmed11@me.com';
    passwordController.text = '12345678';

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserAfterLoginSuccessState) {
            showFlutterToast(
              message: 'Login Successfully ${state.message}',
              toastColor: Colors.green,
            );
            //her we check type of user to navigat to his main screen
            if (state.message == AppStrings.admin) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
                (route) => false,
              );
            } else if (state.message == AppStrings.hospital) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HospitalHomeScreen(),
                ),
                (route) => false,
              );
            } else if (state.message == AppStrings.mother) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MotherHomeScreen(),
                ),
                (route) => false,
              );
            } else if (state.message == AppStrings.doctor) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoctorHomeScreen(),
                ),
                (route) => false,
              );
            }
          }
          if (state is AuthGetUserAfterLoginErrorState) {
            showFlutterToast(
              message: state.error,
              toastColor: Colors.red,
            );
          }
        },
        builder: (context, state) {
          AuthCubit authCubit = AuthCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(AppAssets.appLogo),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        AppSizedBox.h5,
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormFiledComponent(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                hintText: 'Email',
                                prefixIcon: Icons.email,
                                validate: (value) {
                                  return Validations.emailValidation(value,
                                      name: 'your email');
                                },
                              ),
                              AppSizedBox.h3,
                              TextFormFiledComponent(
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                hintText: 'Password',
                                prefixIcon: Icons.lock,
                                suffixIcon: Icons.visibility,
                                obscureText: true,
                                validate: (value) {
                                  return Validations.passwordValidation(value,
                                      name: 'your password');
                                },
                              ),
                              AppSizedBox.h5,
                              state is AuthGetUserAfterLoginLoadingState
                                  ? const CircularProgressComponent()
                                  : BottomComponent(
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          // email must not has any space
                                          emailController.text = emailController
                                              .text
                                              .replaceAll(' ', '')
                                              .toLowerCase();
                                          setState(() {});
                                          authCubit.login(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
