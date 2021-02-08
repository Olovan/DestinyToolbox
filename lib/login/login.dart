import 'package:Destiny2Toolbox/inventory/inventory.dart';
import 'package:Destiny2Toolbox/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatelessWidget {
  BuildContext context; 
  AuthService authService;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    this.context = context;
    this.authService = GetIt.instance<AuthService>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Login",
          style: theme.textTheme.headline1,
        ),
        Text(authService.accessToken ?? "", style: theme.textTheme.bodyText1),
        Center(
          child: RaisedButton(
            onPressed: loginPressed,
            child: Text("Login"),
          ),
        ),
      ],
    );
  }

  void loginPressed() {
    authService.loginUser();
  }
}
