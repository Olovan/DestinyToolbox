import 'package:Destiny2Toolbox/services/auth.dart';
import 'package:Destiny2Toolbox/services/player-info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  BuildContext context;
  AuthService authService;
  PlayerInfoService playerInfo;
  String username;
  

  @override
  void initState() {
    super.initState();
    this.playerInfo = GetIt.instance<PlayerInfoService>();
    retrieveUserInformation();
  }
    
      @override
      Widget build(BuildContext context) {
        this.context = context;
        var textTheme = Theme.of(context).textTheme;
    
        String warlock =
            "https://bungie.net/common/destiny2_content/icons/a8cc3b92697af4cc803ad35c72e67635.png";
        String titan =
            "https://bungie.net/common/destiny2_content/icons/05cb3235ebae6d3f09e196c0e97ae4ea.png";
        String hunter =
            "https://bungie.net/common/destiny2_content/icons/1a21d9aa4274b141e0396a5c0609ff22.png";
    
    
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Text(username ?? "LOADING...", style: textTheme.headline3),
              playerInventory("Warlock", warlock),
              playerInventory("Hunter", hunter),
              playerInventory("Titan", titan),
            ]),
          ),
        );
      }
    
      Widget playerInventory(String name, String icon) {
        ThemeData theme = Theme.of(context);
    
        return Container(
          child: Column(
            children: [
              playerHeader(icon, name, theme),
              items(),
              Container(
                height: 20,
              )
            ],
          ),
        );
      }
    
      Widget items() {
        List<Widget> items = [];
        String itemIconUrl =
            "https://www.bungie.net/common/destiny2_content/icons/e1ad2683c69e93c1e3cf9f41f98858e6.jpg?cv=3983621215";
        for (int i = 0; i < 50; i++) {
          items.add(itemIcon(itemIconUrl));
        }
    
        return Wrap(
          direction: Axis.horizontal,
          children: items,
        );
      }
    
      Widget itemIcon(String itemIcon) {
        return Padding(
            padding: EdgeInsets.all(5), child: Image.network(itemIcon, height: 50));
      }
    
      Widget playerHeader(String icon, String name, ThemeData theme) {
        return Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
              child: Image.network(
                icon,
                height: 80,
              ),
            ),
            Text(
              name,
              style: theme.textTheme.headline4,
            ),
            Container(
              width: 50,
            ),
          ],
        );
      }
    
      void retrieveUserInformation() async {
        var info = await this.playerInfo.getCurrentUserInfo();
        if(info != null) {
          setState(() {
            this.username = info.name;
          });
        }
      }
}
