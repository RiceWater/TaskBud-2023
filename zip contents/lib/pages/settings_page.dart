import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 2.5/100, 0, 0)),
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 7.5/100, 0, 0, 0)),
              Row(
                children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage('https://picsum.photos/id/237/200/300'),
                  minRadius: 30,
                  maxRadius: 30,
                ),
                Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 5/100, 0, 0, 0)),
                const Text('Biggus Dikus',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              ],),
              const Spacer(),
              IconButton(onPressed: () {
                print('Icon Pressed!');
              },
              icon: const Icon(Icons.more_vert)),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 5/100, 0)),
          ]),
          Padding(padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 2.5/100, 0, 0)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 90/100,
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.sync),
                  horizontalTitleGap: 0,
                  title: const Text('Sync Data'),
                  onTap: () {
                    print('pressed');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.dark_mode), // Icon widget as the leading element
                  title: Text('Dark Mode'),
                  horizontalTitleGap: 0, // Title of the ListTile
                  trailing: Switch(
                    value: true, //_switchValue,
                    onChanged: (value) {
                      // setState(() {
                      //   // _switchValue = value;
                      // });
                    },
                  ), // Switch widget as the trailing element
                  onTap: () {
                    setState(() {
                      // _switchValue = !_switchValue;
                    });
                  }, // Optional onTap callback
                ),
                ListTile(
                  leading: Icon(Icons.pets), // Icon widget as the leading element
                  title: Text('App Buddy'),
                  horizontalTitleGap: 0, // Title of the ListTile
                  trailing: Switch(
                    value: true, //_switchValue,
                    onChanged: (value) {
                      // setState(() {
                      //   // _switchValue = value;
                      // });
                    },
                  ), // Switch widget as the trailing element
                  onTap: () {
                    setState(() {
                      // _switchValue = !_switchValue;
                    });
                  }, // Optional onTap callback
                ),
                ListTile(
                  leading: const Icon(Icons.music_note_rounded),
                  horizontalTitleGap: 0,
                  title: const Text('Sounds'),
                  onTap: () {
                    print('pressed');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  horizontalTitleGap: 0,
                  title: const Text('FAQ'),
                  onTap: () {
                    print('pressed');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  horizontalTitleGap: 0,
                  title: const Text('Feedback'),
                  onTap: () {
                    print('pressed');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.question_mark_outlined),
                  horizontalTitleGap: 0,
                  title: const Text('About App'),
                  onTap: () {
                    print('pressed');
                  },
                ),
              ],
            ),
          ),
        //Column ends in this bracket ]
        ],
      )),
    ));
  }
}
