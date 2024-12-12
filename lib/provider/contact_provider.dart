import 'package:flutter/material.dart';
import 'package:interview_coding_test/helper/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modal/contact_modal.dart';
import '../helper/api_helper.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> contacts = [];
  List databaseData = [];
  int _currentPage = 1;
  bool isFetching = false;
  int _totalContacts = 0;

  Future<void> fetchContacts() async {
    if (isFetching ||
        (_totalContacts > 0 && contacts.length >= _totalContacts)) {
      // Stop fetching if already fetching or all contacts are loaded
      return;
    }

    isFetching = true;
    notifyListeners();

    try {
      final contactResponse = await ApiHelper.fetchContacts(_currentPage);

      // Adding all data to contacts list
      contacts.addAll(contactResponse.contacts);
      _totalContacts = contactResponse.total;

      if (_currentPage < contactResponse.totalPages) {
        _currentPage++;
      }
    } catch (e) {
      // If their is some error exception will be thrown
      throw Exception('Error fetching contacts: $e');
    }

    isFetching = false;
    await insertData();
    notifyListeners();
  }

  void mailLaunch(String email) {
    String subject = Uri.encodeComponent('Mail Subject'); // Properly encodes spaces
    String body = Uri.encodeComponent("Dear Sir/Mam,\n");
    Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body', // Use encoded parameters
    );
    launchUrl(uri);
  }

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  Future<void> insertData() async {
    // Removing all data from database
    await DatabaseHelper.databaseHelper.deleteData();

    // inserting data in database
    for (int i = 0; i < contacts.length; i++) {
      await DatabaseHelper.databaseHelper.insertData(
        id: contacts[i].id,
        email: contacts[i].email,
        firstName: contacts[i].firstName,
        lastName: contacts[i].lastName,
        avtar: contacts[i].avatar,
      );
    }
  }

  Future<List<Map<String, Object?>>> readDataFromDatabase() async {
    return databaseData = await DatabaseHelper.databaseHelper.readData();
  }

  ContactProvider() {
    initDatabase();

    fetchContacts();
  }
}
