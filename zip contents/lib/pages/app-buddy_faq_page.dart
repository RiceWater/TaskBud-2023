import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/databases/settings_database.dart';

class AppBuddyFAQScreen extends StatefulWidget {
  const AppBuddyFAQScreen({super.key});

  @override
  _AppBuddyFAQScreenState createState() => _AppBuddyFAQScreenState();
}

class _AppBuddyFAQScreenState extends State<AppBuddyFAQScreen> {
  List<FAQItem> faqItems = [
    FAQItem(
        headerContent: "What are the benefits of using this app?",
        expandedContent:
            "Our notetaking and task-making app has numerous benefits. Firstly, it allows you to organize and prioritize your tasks and notes, which helps you stay on top of your work and increase productivity. Secondly, you can set reminders for important tasks or notes, ensuring that you never miss a deadline or forget an essential piece of information. Additionally, our app has a user-friendly interface that makes it easy to use and navigate, even for those who are not tech-savvy. Overall, our app is an excellent tool for anyone looking to enhance their productivity and streamline their workflow."),
    FAQItem(
        headerContent: "How do you handle user data?",
        expandedContent:
            " We take user privacy very seriously, and we do not collect any user data. Our app does not require any personal information or login credentials, ensuring that your privacy remains intact. We understand the importance of data security, and we use industry-standard encryption techniques to protect user data, which in this case, is none."),
    FAQItem(
        headerContent:
            "How long does it take to receive a response from customer support?",
        expandedContent:
            "We strive to provide our customers with the best possible service and support. Our customer support team aims to available 24/7 to answer any questions or concerns you may have. We aim to respond to all queries as soon as possible. However, due to the size of the team, we ask for patience. But would not ask for more than a week."),
    FAQItem(
        headerContent: "What forms of payment do you accept?",
        expandedContent:
            "We do not accept payments for our app, as it is currently free to use. However, if you would like to support our development efforts, we accept donations of any amount. In the future, we may introduce premium features that may require payment, but we will ensure that our app remains accessible and affordable for all users. Thank you for considering supporting our app!"),
    FAQItem(
        headerContent: "Will this always be free?",
        expandedContent:
            "We understand that many users appreciate the availability of free apps. As of now, our app is free to use, and we intend to keep it that way. However, we may introduce premium features in the future that may come with a cost. Nevertheless, we promise to keep our app accessible and affordable for all our users."),
  ];

  //https://api.flutter.dev/flutter/material/ExpansionPanelList-class.html
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {});
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
                              title: Text(item.headerContent,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, height: 2)),
                            ),
                          );
                        },
                        body: ListTile(
                          dense: false,
                          title: Text(item.expandedContent,
                              style: const TextStyle(height: 2)),
                        ),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  )
                ],
              ),
            )));
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
