import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> notes = [];
  TextEditingController noteController = TextEditingController();

  // Bool values for on/off toggle for general settings
  bool vGen1 = true;
  bool vGen2 = true;
  bool vGen3 = true;

  onChangeFunction1(bool newValue1) {
    setState(() {
      vGen1 = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      vGen2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      vGen3 = newValue3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            const SizedBox(height: 5),
            Row(
              children: const [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 5),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 10),
            buildAccountOption(context, "Change Credentials"),
            buildAccountOption(context, "Language"),
            buildAccountOption(context, "Privacy and Security"),
            const SizedBox(height: 40),
            Row(
              children: const [
                Icon(Icons.settings_sharp, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "General",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            const SizedBox(height: 10),

            // GENERAL settings list of options and bool changes
            buildGeneralOption("Dark Theme", vGen1, onChangeFunction1),
            buildGeneralOption("Task Buddy", vGen2, onChangeFunction2),
            buildGeneralOption("App Sounds", vGen3, onChangeFunction3),

            const SizedBox(height: 30),

            // SIGN OUT button
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
                child: const Text(
                  "SIGN OUT",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Design and actions of GENERAL settings
Padding buildGeneralOption(String title, bool value, Function onChangeMethod) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            activeColor: Colors.blue,
            trackColor: Colors.grey[300],
            value: value,
            onChanged: (bool newValue) {
              onChangeMethod(newValue);
            },
          ),
        ),
      ],
    ),
  );
}

// Design and actions of ACCOUNT settings
GestureDetector buildAccountOption(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("Option 1"),
                Text("Option 2"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800]),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[800])
        ],
      ),
    ),
  );
}
