import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_event.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_state.dart';
import 'package:todo/feature/presentation/widgets/auth_button.dart';
import 'package:todo/feature/presentation/widgets/login_field.dart';
import 'package:todo/feature/presentation/widgets/nickname_field.dart';
import 'package:todo/feature/presentation/widgets/password_field.dart';
import 'package:todo/todo_navigator.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();

  SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            Navigator.of(context).pushReplacementNamed(Routes.homePage);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 180.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is Pending) {
            return SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            'VzhTodo',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...[
                          TextFieldLogin(controller: _loginController),
                          NicknameField(controller: _nicknameController),
                          TextFieldPassword(controller: _passwordController),
                          AuthButton(
                              label: 'Sign Up',
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;

                                BlocProvider.of<AuthBloc>(context).add(
                                  SignUpEvent(
                                    email: _loginController.text,
                                    nickName: _nicknameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }),
                          AuthButton(
                            label: 'Back',
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed(Routes.auth),
                          )
                        ].map((e) => Padding(
                              padding: const EdgeInsets.all(12),
                              child: e,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
