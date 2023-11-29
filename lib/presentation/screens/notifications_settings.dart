import 'package:flutter/material.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool _isNotificationEnabled = true;

  bool _isPushEnabled = true;
  bool _isEmailEnabled = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'اعدادات الاشعارات',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تفعيل الاشعارات',
                style: TextStyle(fontSize: 16.0),
              ),
              Switch(
                value: _isNotificationEnabled,
                onChanged: (value) {
                  setState(() {
                    _isNotificationEnabled = value;
                  });
                },
              ),
            ],
          ),

          const Divider(height: 32.0),
          const Text(
            'Delivery Settings',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Push Notifications',
                style: TextStyle(fontSize: 16.0),
              ),
              Switch(
                value: _isPushEnabled,
                onChanged: (value) {
                  setState(() {
                    _isPushEnabled = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Email Notifications',
                style: TextStyle(fontSize: 16.0),
              ),
              Switch(
                value: _isEmailEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEmailEnabled = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
