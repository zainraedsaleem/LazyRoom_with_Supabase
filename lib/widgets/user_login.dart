import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/models/login_request_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/auth_service.dart';
import 'package:takroom/services/local_storage_service.dart';
import 'package:takroom/services/role_router.dart';
import 'package:takroom/widgets/login_text_field.dart';
import 'package:takroom/widgets/password_text_field.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  int currentIndex = 0;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginTextField(
          labelText: "Email",
          hintText: "Please enter your university ID",
          controller: emailController,
          icon: Icons.alternate_email,
        ),
        PasswordTextField(
          labelText: "Password",
          hintText: "Please enter your password",
          controller: passwordController,
        ),

        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.black,
            minimumSize: Size(double.infinity, 50),
            textStyle: TextStyle(fontSize: 25),
          ),
          onPressed: () async {
            final user = LoginRequestModel(
              email: emailController.text,
              password: passwordController.text,
            );
            bool success = await AuthService().login(user.email, user.password);
            if (success) {
              ShowSnackbar.showSnackbar(context, "Login successful");
              final user = await AuthService().getCurrentUserProfile();
              if (user.isBanned) {
                await AuthService().logout();
                ShowSnackbar.showSnackbar(
                  context,
                  "This account has been banned",
                );
                return;
              }
              Provider.of<UserProvider>(
                context,
                listen: false,
              ).setUser(user); /*
              await LocalStorageService.saveUserData(
                token: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.token,
                role: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.role,
                name: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.name,
                email: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.email,
                balance: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.balance,
                build: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.building,
                room_number: Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).user!.room_number,
              );*/
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => getHomePageByRole(
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).user!.role,
                  ),
                ),
              );
            } else {
              ShowSnackbar.showSnackbar(context, "Login Faild");
            }
          },

          child: Text("Login"),
        ),
      ],
    );
  }
}
