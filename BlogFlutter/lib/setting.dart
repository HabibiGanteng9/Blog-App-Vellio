import 'package:flutter/material.dart';
import 'package:latihan_rpl_2/loginPage.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  final String username;
  final String email;

  const SettingsScreen({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FA),

      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: "ComicRelie2f",
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        backgroundColor: Color(0xFFF6F5FA),
        elevation: 0,
      ),

      body: SettingsList(
        lightTheme: SettingsThemeData(settingsSectionBackground: Colors.white),
        sections: [
          SettingsSection(
            title: const Text(
              'Account',
              style: TextStyle(
                color: Colors.blueAccent,
                fontFamily: "ComicRelief",
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: [
              SettingsTile(
                leading: const Icon(
                  Icons.account_circle,
                  size: 40,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  widget.username,
                  style: const TextStyle(
                    fontFamily: "ComicRelief",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                description: Text(
                  widget.email,
                  style: const TextStyle(
                    fontFamily: "ComicRelief",
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          SettingsSection(
            title: const Text(
              'General',
              style: TextStyle(
                color: Colors.blueAccent,
                fontFamily: "ComicRelief",
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language, color: Colors.blueAccent),
                title: const Text(
                  'Language',
                  style: TextStyle(fontFamily: "ComicRelief"),
                ),
                value: const Text(
                  'English',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "ComicRelief",
                  ),
                ),
                onPressed: (context) {
                  /* navigate */
                },
              ),
            ],
          ),

          SettingsSection(
            title: const Text(
              'Appearance',
              style: TextStyle(
                color: Colors.blueAccent,
                fontFamily: "ComicRelief",
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: [
              SettingsTile.switchTile(
                leading: const Icon(Icons.dark_mode, color: Colors.blueAccent),
                title: const Text(
                  'Dark mode',
                  style: TextStyle(fontFamily: "ComicRelief"),
                ),
                initialValue: _darkMode,
                activeSwitchColor: Colors.blueAccent,
                onToggle: (value) => setState(() => _darkMode = value),
              ),

              SettingsTile.switchTile(
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.blueAccent,
                ),
                title: const Text(
                  'Notifications',
                  style: TextStyle(fontFamily: "ComicRelief"),
                ),
                description: const Text(
                  'Alerts, sounds, badges',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "ComicRelief",
                  ),
                ),
                initialValue: _notificationsEnabled,
                activeSwitchColor: Colors.blueAccent,
                onToggle: (value) =>
                    setState(() => _notificationsEnabled = value),
              ),
            ],
          ),

          SettingsSection(
            title: const Text(
              'Account',
              style: TextStyle(
                color: Colors.blueAccent,
                fontFamily: "ComicRelief",
                fontWeight: FontWeight.bold,
              ),
            ),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: "ComicRelief",
                  ),
                ),
                onPressed: (context) {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
