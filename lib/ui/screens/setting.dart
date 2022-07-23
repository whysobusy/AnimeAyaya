import 'package:anime_player/constant.dart';
import 'package:anime_player/ui/widgets/anime_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Settings class
class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  final bool showAppBar;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //final global = Global();
  bool? hideDUB;
  late String input;
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    // TODO cache
    hideDUB = true;
    const currentDomain = Constant.defaultDomain;
    controller =
        TextEditingController.fromValue(const TextEditingValue(text: currentDomain));
    input = currentDomain;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: const Text('Settings')) : null,
      body: ListView(
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            title: const Text('Support me :)'),
            subtitle: const Text(
                'If you really like this app, you can consider buying me a pizza but any amount is greatly appreciated'),
            onTap: () => launch('https://www.paypal.me/yihengquan'),
          ),
          ListTile(
            title: const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Website link'),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  maxLines: 1,
                  autocorrect: false,
                  controller: controller,
                  autofocus: false,
                  onChanged: (value) => input = value,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    //global.updateDomain(this.input);
                    Future.delayed(const Duration(milliseconds: 400)).then(
                      (_) => showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Domain has been updated'),
                          content: Text(
                            "The domain is now $input.\n\nIf it doesn't load, please change it back to the default domain. Note that the app will always get the latest domain based on the saved domain automatically and it might override your custom domain.",
                          ),
                          actions: [
                            AnimeFlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "The link will be updated automatically.\nIn certain regions, this website doesn't work.\nTry using a VPN and restart the app.\nPlease tap me and check if it works for you.\n\nDon't change it if you don't know what you are doing.\nThe default domain is ${Constant.defaultDomain}.\nPlease try updating to the default if current one is not working.",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
            onTap: () => launch(Constant.defaultDomain),
          ),
          CheckboxListTile(
            title: const Text('Hide Dub'),
            subtitle: const Text('Hide all dub anime if you prefer sub'),
            onChanged: (bool? value) => updateHideDUB(value),
            value: hideDUB,
          ),
        ],
      ),
    );
  }

  /// Hides dub
  Future<void> updateHideDUB(bool? value) async {
    if (value == hideDUB) return;
    //global.hideDUB = value;
    setState(() {
      hideDUB = value;
    });
  }
}