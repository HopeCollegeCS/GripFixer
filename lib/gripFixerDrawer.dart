import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GripFixerDrawer extends StatelessWidget {
  const GripFixerDrawer({super.key});

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
              context.push("/RacketSelectPage/:PlayerSelectPage");
            },
          ),
        ],
      ),
    );
  }
}
