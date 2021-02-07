import 'package:Destiny2Toolbox/login/login.dart';
import 'package:Destiny2Toolbox/services/auth.dart';
import 'package:Destiny2Toolbox/services/native.dart';
import 'package:Destiny2Toolbox/services/secrets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await registerServices();
  runApp(MyApp());
}

Future<void> registerServices() async {
  var injector = GetIt.instance;
  Secrets secrets = await Secrets.fromFile("assets/secrets.json");
  var nativeService = NativeIntegrationService();
  var authService = AuthService(nativeService, secrets.clientID, secrets.clientSecret);
  injector.registerSingleton<NativeIntegrationService>(nativeService);
  injector.registerSingleton<Secrets>(secrets);
  injector.registerSingleton<AuthService>(authService);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
