import 'package:Destiny2Toolbox/inventory/inventory.dart';
import 'package:Destiny2Toolbox/login/login.dart';
import 'package:Destiny2Toolbox/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class RootWidget extends StatelessWidget {
  AuthService authService;
  Widget child;
  GlobalKey<NavigatorState> navKey = new GlobalKey();

  RootWidget.withDefaults([Widget redirectWidget]) {
    this.authService = GetIt.instance<AuthService>();
    this.child = redirectWidget ?? InventoryPage();
  }

  RootWidget(this.authService, this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String>(
        stream: authService.accessTokenStream,
        builder: (context, authToken) {
          if (authService.accessToken != null) {
            return WillPopScope(
              onWillPop: () async {
                navKey.currentState.maybePop();
                return false;
              },
              child: Navigator(
                  key: navKey,
                  initialRoute: '/inventory',
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                      case '/inventory': return MaterialPageRoute(builder: (_) => InventoryPage());
                      default: return null;
                    }
                  }),
            );
          } else {
            return LoginPage();
          }
        }));
  }
}
