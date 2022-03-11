import 'package:flutter/material.dart';

bool notification = true;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool notifications = true;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
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
                _showAbout();
              },
              leading: Icon(Icons.account_circle_outlined),
              title: Text('About'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Notifications'),
              trailing: Switch.adaptive(
                  value: notification,
                  onChanged: (value) {
                    setState(() {
                      notification = value;
                    });
                    print(notification);
                  }),
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

  Future<dynamic> _showAbout() {
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
