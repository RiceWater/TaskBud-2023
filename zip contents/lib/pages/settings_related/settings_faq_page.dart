import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

class SettingsFAQScreen extends StatefulWidget {
  const SettingsFAQScreen({super.key});

  @override
  _SettingsFAQScreenState createState() => _SettingsFAQScreenState();
}

class _SettingsFAQScreenState extends State<SettingsFAQScreen> {

  List<FAQItem> faqItems = [
    FAQItem(headerContent: "What are the benefits of using this app?", 
        expandedContent: "There are a lot of benefits, but generally, you can increase your productivity and focus, plan your day better, and feel more accountable with what you do."),
    FAQItem(headerContent: "How do you handle user data?", 
        expandedContent: "Currently, your data will used for backups in case it was deleted locally or if you are signing in with another device."),
    FAQItem(headerContent: "How long does it take to receive a response from customer support?", 
        expandedContent: "Since this is made by a small team, you'll be receiving a response within a week."),
    FAQItem(headerContent: "What forms of payment do you accept?", 
        expandedContent: "As of now, we are not accepting any payment of any kind. If we will, it might be in a form of a donation."),
    FAQItem(headerContent: "Will this always be free?", 
        expandedContent: "Yes, it will!"),
  ];

  //https://api.flutter.dev/flutter/material/ExpansionPanelList-class.html
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                });
                Navigator.pop(context);
                //Navigator.pop(context, name);
              },
            ),
            title: Row(
              children: [
                const Text('FAQ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),


        body: SingleChildScrollView(
          child: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    faqItems[index].isExpanded = !isExpanded;
                  });
                },
                children: faqItems.map<ExpansionPanel>((FAQItem item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            item.isExpanded = !item.isExpanded;
                          });
                        },
                        child: ListTile(
                          title: Text(item.headerContent, style: const TextStyle(fontWeight: FontWeight.bold, height: 2)),
                        ),
                      );
                    },
                    body: ListTile(
                        dense: false,
                        title: Text(item.expandedContent, style: const TextStyle(height: 2)),
                        ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              )
            ],
          ),
        )
      )
    );
  }
}

class FAQItem {
  FAQItem({
    required this.expandedContent,
    required this.headerContent,
    this.isExpanded = false,
  });

  String expandedContent;
  String headerContent;
  bool isExpanded;
}