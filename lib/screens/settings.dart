import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

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
              onTap: () {},
              leading: Icon(Icons.account_circle_outlined),
              title: Text('About'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Notifications'),
              trailing: Switch(
                inactiveTrackColor: Colors.grey.shade300,
                inactiveThumbColor: Colors.grey,
                activeTrackColor: Colors.grey.shade300,
                activeColor: Colors.grey,
                value: notifications,
                onChanged: (value) {},
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.report_rounded),
              title: Text('Privacy Policy'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text('Tearms and conditions'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.verified),
              title: Text('Version'),
              trailing: Text('1.01.01'),
            ),
          ],
        ),
      ),
    );
  }
}
