import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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

  Future<void> deletePlayerDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'player_database.db');
    await deleteDatabase(path);
  }

  void showDatabaseDeletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Database Successfully Deleted',
              textAlign: TextAlign.center),
          content: const Text('You may need to restart the app',
              textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF5482ab),
            ),
            child: Text(''),
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
          ListTile(
            title: const Text('Delete Database'),
            onTap: () {
              deletePlayerDatabase().then((_) {
                showDatabaseDeletedDialog(context);
              });
            },
          ),
          ListTile(
            title: const Text('See sensor values'),
            onTap: () {
              context.push("/RacketSelectPage/SensorRead");
            },
          ),
          FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text(
                              'Version: ${snapshot.data!.version} build ${snapshot.data!.buildNumber}')),
                    );

                  default:
                    return const SizedBox();
                }
              })
        ],
      ),
    );
  }
}
