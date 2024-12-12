import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interview_coding_test/modal/contact_modal.dart';
import 'package:provider/provider.dart';
import '../provider/contact_provider.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final screenSize = MediaQuery.sizeOf(context);
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0.1,
        backgroundColor: Colors.indigo,
        leading: const Icon(Icons.account_circle_sharp),
        title: const Text(
          'Contacts',
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.contains(ConnectivityResult.wifi) ||
              snapshot.data!.contains(ConnectivityResult.mobile)) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !contactProvider.isFetching) {
                  // Loading more data when the user scrolls at the bottom
                  contactProvider.fetchContacts();
                }
                return true;
              },
              child: Column(
                children: [
                  Expanded(
                    child: contactProvider.contacts.isEmpty &&
                            !contactProvider.isFetching
                        // Checking whether their is contact or not in the list
                        ? const Center(
                            child: Text(
                              'No Contacts Available',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        // Displaying data is their is data in the list
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            itemCount: contactProvider.contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contactProvider.contacts[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 8 : 12,
                                    horizontal: isSmallScreen ? 12 : 16,
                                  ),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.indigo,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: isSmallScreen ? 25 : 30,
                                      backgroundImage:
                                          NetworkImage(contact.avatar),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ),
                                  title: Text(
                                    '${contact.firstName} ${contact.lastName}',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    contact.email,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  onTap: () {
                                    // Navigating and sending detail of the selected contact in the contact detail page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ContactDetailPage(contact: contact),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  // Showing loader when data fetching is in process
                  if (contactProvider.isFetching)
                    const CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            // Displaying data from database when user is offline
            return FutureBuilder(
                future: contactProvider.readDataFromDatabase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }

                  List<Contact> databaseDetails;
                  databaseDetails = contactProvider.databaseData
                      .map(
                        (e) => Contact.fromJson(e),
                      )
                      .toList();

                  Fluttertoast.showToast(
                    msg: "You're currently offline fetching data from database",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                  );
                  return Column(
                    children: [
                      Expanded(
                        child: contactProvider.contacts.isEmpty &&
                                !contactProvider.isFetching
                            // Checking whether their is contact or not in the list
                            ? const Center(
                                child: Text(
                                  'No Contacts Available',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              )
                            // Displaying data is their is data in the list
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                itemCount: contactProvider.databaseData.length,
                                itemBuilder: (context, index) {
                                  final contact = databaseDetails[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: isSmallScreen ? 8 : 12,
                                        horizontal: isSmallScreen ? 12 : 16,
                                      ),
                                      leading: CircleAvatar(
                                        radius: isSmallScreen ? 25 : 30,
                                        backgroundImage:
                                            NetworkImage(contact.avatar),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      title: Text(
                                        '${contact.firstName} ${contact.lastName}',
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      subtitle: Text(
                                        contact.email,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      onTap: () {
                                        // Navigating and sending detail of the selected contact in the contact detail page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ContactDetailPage(
                                                    contact: contact),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                      // Showing loader when data fetching is in process
                      if (contactProvider.isFetching)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  );
                });
          }
        },
      ),
    );
  }
}
