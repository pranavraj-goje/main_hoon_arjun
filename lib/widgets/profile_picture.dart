// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/settings_screen.dart';
import '../providers/mahabharat_characters.dart';

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, SettingsScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: CircleAvatar(
          backgroundColor: Colors.orange.shade50,
          radius: 30,
          child: Image.asset(
            Provider.of<MahabharatCharacters>(context, listen: true)
                .getChosenAvatarLink(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
