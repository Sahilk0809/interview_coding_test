import 'package:flutter/material.dart';
import 'package:interview_coding_test/helper/database_helper.dart';
import '../modal/contact_modal.dart';
import '../helper/api_helper.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> contacts = [];
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

      contacts.addAll(contactResponse.contacts);
      _totalContacts = contactResponse.total;

      if (_currentPage < contactResponse.totalPages) {
        _currentPage++;
      }
    } catch (e) {
      throw Exception(
          'Error fetching contacts: $e'); // if their is some error exception will be thrown
    }

    isFetching = false;
    notifyListeners();
  }

  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  Future<void> readDataFromDatabase() async {
    await DatabaseHelper.databaseHelper.readData();
  }

  ContactProvider() {
    fetchContacts();
    initDatabase();
  }
}
