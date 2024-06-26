import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GripFixerDrawer extends StatefulWidget {
  const GripFixerDrawer({super.key});

  @override
  GripFixerDrawerState createState() => GripFixerDrawerState();
}

getVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    return packageInfo.version;
  });
}

getBuildNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.buildNumber;
}

class GripFixerDrawerState extends State<GripFixerDrawer> {
  late String version;
  late String buildNumber;

  @override
  // void initState() {
  //   PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
  //     version = packageInfo.version;
  //     buildNumber = packageInfo.buildNumber;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              context.push("/Settings");
            },
          ),
          ListTile(
            title: const Text('Connect to Sensor'),
            onTap: () {
              context.push("/RacketSelectPage/PlayerSelectPage");
            },
          ),
        ],
      ),
    );
  }
}
