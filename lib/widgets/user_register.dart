import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takroom/controllers/auth_controller.dart';
import 'package:takroom/models/register_request_model.dart';
import 'package:takroom/providers/user_provider.dart';
import 'package:takroom/services/auth_service.dart';
import 'package:takroom/services/role_router.dart';
import 'package:takroom/widgets/login_text_field.dart';
import 'package:takroom/widgets/password_text_field.dart';
import 'package:takroom/widgets/dialogs/show_snackbar.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginTextField(
          labelText: "Full name",
          hintText: "Please enter your Full name",
          controller: authController.namecontroller,
          icon: Icons.person_2_outlined,
        ),
        LoginTextField(
          labelText: "Email",
          hintText: "Please enter your Email",
          controller: authController.emailcontroller,
          icon: Icons.alternate_email,
        ),
        PasswordTextField(
          labelText: "Password",
          hintText: "Please enter your Password",
          controller: authController.passwordcontroller,
        ),
        LoginTextField(
          labelText: "Unit Number",
          hintText: "Please enter your Unit number",
          controller: authController.buildingNumbercontroller,
          icon: Icons.apartment_outlined,
          isInt: true,
        ),
        LoginTextField(
          labelText: "Room Number",
          hintText: "floor/room Like: 122",
          controller: authController.roomNumbercontroller,
          icon: Icons.door_front_door_outlined,
          isInt: true,
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
            final user = RegisterRequestModel(
              email: authController.emailcontroller.text,
              password: authController.passwordcontroller.text,
              name: authController.namecontroller.text,
              buildingNumber: authController.buildingNumbercontroller.text,
              roomNumber: authController.roomNumbercontroller.text,
            );
            bool success = await AuthService().register(user);
            if (success) {
              ShowSnackbar.showSnackbar(context, "Register successful");
              final user = await AuthService().getCurrentUserProfile();
              Provider.of<UserProvider>(context, listen: false).setUser(user);
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
          child: Text("Create Account"),
        ),
      ],
    );
  }
}
