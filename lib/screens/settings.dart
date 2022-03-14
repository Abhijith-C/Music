import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                _showAbout(context);
              },
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('About'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Notifications'),
              trailing: GetBuilder<Controller>(
                builder: (control) {
                  return Switch.adaptive(
                      value: control.notification,
                      onChanged: (value) {
                        control.notificationCheck(value);
                      });
                },
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.report_rounded),
              title: Text('Privacy Policy'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.flag),
              title: Text('Tearms and conditions'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text('Version'),
              trailing: Text('1.01.01'),
            ),
          ],
        ),
      ),
    );
  }
  Future<dynamic> _showAbout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          applicationName: "Light Music",
          applicationVersion: "Version 1.01.01",
          applicationIcon: Image.asset(
            'assets/images/logo.png',
            width: 60.0,
            height: 60.0,
          ),
        );
      },
    );
  }
}
